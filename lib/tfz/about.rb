# frozen_string_literal: true

module Tfz
  # Facts for the About screen (`?` in the TUI, `tfz about` on the command line).
  module About
    NAME = 'tfz'
    TAGLINE = 'Terminal Feedz, a terminal RSS/Atom feed reader'
    ORGANIZATION = 'Nine Point Labs'
    SUPPORT_EMAIL = 'help@ninepointlabs.com'
    CREATED = 'January 2026' # first commit: 2026-01-21
    LICENSE_NAME = 'MIT License'
    COPYRIGHT = '© 2026 Nine Point Labs' # as written in LICENSE
    LICENSE_FILE = File.expand_path('LICENSE.txt', __dir__)

    PRIVACY = 'No accounts, analytics or telemetry. tfz only connects to the ' \
              'feed URLs you subscribe to (when you browse or refresh feeds) and, ' \
              "when you open an article, to that article's web page to fetch its " \
              'full text; images are not downloaded. Your feed list is kept in ' \
              '~/.config/tfz/config.yml and your read/unread state in ' \
              '~/.cache/tfz/read_articles.yml, on this computer only. Opening a ' \
              'link hands it to your browser.'

    GEMS = %w[feedjira http nokogiri ruby-readability tty-reader tty-markdown pastel rouge].freeze

    module_function

    def license_text
      File.read(LICENSE_FILE)
    rescue SystemCallError
      "#{LICENSE_NAME}, #{COPYRIGHT}"
    end

    def gem_versions
      GEMS.filter_map do |name|
        spec = Gem.loaded_specs[name]
        "#{name} #{spec.version}" if spec
      end
    end

    def built_with
      (["Ruby #{RUBY_VERSION}"] + gem_versions).join(', ')
    end

    # Version and system details to paste into a support email.
    def details
      desktop = ENV['XDG_CURRENT_DESKTOP'] || 'unknown desktop'
      "#{NAME} #{VERSION}\n#{built_with}\n#{RUBY_PLATFORM}, #{desktop}, TERM=#{ENV['TERM'] || 'unknown'}"
    end

    def mailto_url
      "mailto:#{SUPPORT_EMAIL}?subject=#{encode("#{NAME} #{VERSION}")}" \
        "&body=#{encode("\n\n--\n#{details}")}"
    end

    def encode(text)
      text.b.gsub(/[^A-Za-z0-9_.~-]/n) { |c| format('%%%02X', c.ord) }
    end

    # Copies text with the first clipboard tool found; returns its name or nil.
    def copy_to_clipboard(text)
      tools = []
      tools << %w[wl-copy] if ENV['WAYLAND_DISPLAY']
      tools << %w[xclip -selection clipboard] << %w[xsel --clipboard --input] if ENV['DISPLAY']
      tools.each do |cmd|
        next unless system('which', cmd[0], out: File::NULL, err: File::NULL)

        IO.popen(cmd, 'w', err: File::NULL) { |io| io.write(text) }
        return cmd[0] if $?.success?
      end
      nil
    end

    def open_url(url)
      %w[xdg-open open].each do |opener|
        next unless system('which', opener, out: File::NULL, err: File::NULL)

        return system(opener, url, out: File::NULL, err: File::NULL)
      end
      false
    end

    # The About screen as plain text, one entry per line.
    def lines
      [
        "#{NAME} #{VERSION}",
        TAGLINE,
        '',
        "Made by    #{ORGANIZATION}",
        "Created    #{CREATED}",
        "License    #{LICENSE_NAME}, #{COPYRIGHT}",
        "Support    #{SUPPORT_EMAIL}",
        "Built with #{built_with}",
        '',
        "Privacy    #{PRIVACY}"
      ]
    end
  end
end
