# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require 'stringio'
require_relative '../lib/tfz'

class AboutTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)

  def test_facts
    assert_equal 'Nine Point Labs', Tfz::About::ORGANIZATION
    assert_equal 'help@ninepointlabs.com', Tfz::About::SUPPORT_EMAIL
    assert_includes Tfz::About.lines.first, Tfz::VERSION
    assert_match(/\ARuby #{Regexp.escape(RUBY_VERSION)}, feedjira /, Tfz::About.built_with)
  end

  def test_bundled_license_matches_repo_license
    license = File.read(File.join(ROOT, 'LICENSE'))
    assert_equal license, Tfz::About.license_text
    assert_includes license, Tfz::About::LICENSE_NAME
    assert_includes license, Tfz::About::COPYRIGHT.sub('©', 'Copyright (c)')
  end

  def test_mailto_is_prefilled_with_version_details
    url = Tfz::About.mailto_url
    assert url.start_with?("mailto:help@ninepointlabs.com?subject=tfz%20#{Tfz::VERSION}&body=")
    refute_match(/[ \n]/, url)
    body = URI.decode_www_form_component(url.split('&body=').last.gsub('+', '%2B'))
    assert_includes body, Tfz::About.details
    assert_includes body, "Ruby #{RUBY_VERSION}"
  end

  def test_copy_without_a_display_reports_no_tool
    saved = ENV.to_h.slice('WAYLAND_DISPLAY', 'DISPLAY')
    ENV.delete('WAYLAND_DISPLAY')
    ENV.delete('DISPLAY')
    assert_nil Tfz::About.copy_to_clipboard('x')
  ensure
    saved.each { |k, v| ENV[k] = v }
  end

  def test_cli_about
    out = capture_io { Tfz::CLI.start(['about']) }.first
    assert_includes out, "tfz #{Tfz::VERSION}"
    assert_includes out, 'Made by    Nine Point Labs'
    assert_includes out, 'Privacy'
    assert_includes out, 'Permission is hereby granted'
  end
end

class AppAboutTest < Minitest::Test
  FakeConfig = Struct.new(:feeds) do
    def category_names = []
    def feeds_by_category = {}
  end

  FakeReader = Struct.new(:keys) do
    def read_keypress(**) = keys.shift
  end

  def setup
    @app = Tfz::UI::App.new(FakeConfig.new([]))
  end

  def press(*keys)
    @app.instance_variable_set(:@reader, FakeReader.new(keys))
    keys.length.times { @app.send(:handle_input) }
  end

  def mode = @app.instance_variable_get(:@mode)

  def draw(screen)
    TTY::Screen.stub(:height, 30) do
      TTY::Screen.stub(:width, 80) { capture_io { @app.send(screen) }.first }
    end
  end


  def test_question_mark_opens_about_and_esc_returns
    @app.instance_variable_set(:@mode, :feed_list)
    press('?')
    assert_equal :about, mode
    press("\e")
    assert_equal :feed_list, mode
  end

  def test_main_menu_entry_opens_about
    out = draw(:draw_main_menu)
    assert_includes out, 'About'
    assert_includes out, '?:about'
    press('j', 'j', 'j', "\r")
    assert_equal :about, mode
  end

  def test_about_screen_shows_facts_and_toggles_license
    press('?')
    out = draw(:draw_about)
    assert_includes out, 'About tfz'
    assert_includes out, 'Nine Point Labs'
    assert_includes out, 'help@ninepointlabs.com'
    assert_includes out, 'e:email-support y:copy-email l:show-license'
    refute_includes out, 'Permission is hereby granted'
    press('l')
    out = draw(:draw_about)
    assert_includes out, 'l:hide-license'
    lines = @app.send(:about_lines, 80).join("\n")
    assert_includes lines, 'Permission is hereby granted'
  end

  def test_copy_shows_a_message_when_no_clipboard_tool
    press('?')
    Tfz::About.stub(:copy_to_clipboard, nil) { press('y') }
    assert_match(/No clipboard tool found/, @app.instance_variable_get(:@about_message))
    Tfz::About.stub(:copy_to_clipboard, 'wl-copy') { press('y') }
    assert_match(/Copied help@ninepointlabs.com/, @app.instance_variable_get(:@about_message))
  end

  def test_email_opens_mailto
    press('?')
    opened = nil
    Tfz::About.stub(:open_url, ->(url) { opened = url }) { press('e') }
    assert_equal Tfz::About.mailto_url, opened
  end
end
