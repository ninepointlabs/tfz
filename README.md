# Terminal Feedz (tfz)

A beautiful terminal-based RSS/Atom feed reader built with Ruby.

![Ruby](https://img.shields.io/badge/Ruby-3.0+-red?logo=ruby)
![License](https://img.shields.io/badge/License-MIT-blue)

## Features

- 🚀 **Fast and lightweight** - Pure terminal TUI, no browser needed
- 📰 **Full article rendering** - Read complete articles in your terminal
- 📁 **Category organization** - Group feeds by topic
- 🔖 **Read/unread tracking** - Never lose your place
- ⌨️ **Vim-style navigation** - j/k, arrows, and more
- 🎨 **Syntax highlighting** - Code blocks rendered beautifully
- 📝 **Rich formatting** - Headers, lists, blockquotes, links
- 🖼️ **Media placeholders** - Images and videos noted inline
- 💾 **Persistent config** - Feeds and read state saved locally

## Installation

### With autonomix-cli

Install and keep tfz updated from GitHub Releases with [autonomix-cli](https://github.com/ninepointlabs/autonomix-cli):

```bash
autonomix-cli add https://github.com/ninepointlabs/tfz
```

### From Package (Recommended)

**Debian/Ubuntu:**
```bash
sudo dpkg -i tfz_0.1.1_all.deb
```

**Fedora/RHEL:**
```bash
sudo rpm -i tfz-0.1.1-1.fc44.noarch.rpm
```

**Arch Linux:**
```bash
sudo pacman -U tfz-0.1.1-1-any.pkg.tar.zst
```

### From Source

Requires Ruby 3.0+ and Bundler.

```bash
git clone https://github.com/timfallmk/tfz.git
cd tfz
bundle install
./bin/tfz
```

Optionally add to PATH:
```bash
sudo ln -s $(pwd)/bin/tfz /usr/local/bin/tfz
```

## Usage

Launch the TUI:
```bash
tfz
```

### CLI Commands

```bash
tfz              # Launch TUI
tfz add <url>    # Add a feed (prompts for category)
tfz remove <url> # Remove a feed
tfz list         # List configured feeds
tfz about        # Version, license, support and privacy info
```

### Keyboard Shortcuts

**Main Menu:**
| Key | Action |
|-----|--------|
| `↑/↓` or `j/k` | Navigate |
| `Enter` | Select |
| `?` | About tfz |
| `q` | Quit |

**Feed List:**
| Key | Action |
|-----|--------|
| `↑/↓` or `j/k` | Navigate entries |
| `Enter` | Read article |
| `m` | Toggle read/unread |
| `s` | Cycle filter (All/Unread/Read) |
| `c` | Filter by category |
| `r` | Refresh feeds |
| `o` | Open in browser |
| `Esc` | Back to menu |

**Article Reader:**
| Key | Action |
|-----|--------|
| `↑/↓` or `j/k` | Scroll |
| `PgUp/PgDn` | Page scroll |
| `g/G` | Top/Bottom |
| `o` | Open in browser |
| `Esc` or `q` | Back to list |

**About:**

Open it with `?` from any screen, or choose **About** in the main menu. It
shows the version, Nine Point Labs, the license, the support address
([help@ninepointlabs.com](mailto:help@ninepointlabs.com)), what tfz does with
your data, and the Ruby and gem versions.

| Key | Action |
|-----|--------|
| `e` | Email support (opens your mail app with version details filled in) |
| `y` | Copy the support address (needs `wl-copy`, `xclip` or `xsel`) |
| `l` | Show/hide the license text |
| `↑/↓` or `j/k`, `PgUp/PgDn` | Scroll |
| `Esc` or `q` | Back |

## Configuration

**Config file:** `~/.config/tfz/config.yml`

```yaml
feeds:
  - url: https://hnrss.org/frontpage
    name: Hacker News
    category: Tech
  - url: https://blog.ruby-lang.org/feed.xml
    name: Ruby Blog
    category: Programming
categories:
  - Tech
  - Programming
```

**Read state:** `~/.cache/tfz/read_articles.yml`

## Screenshots

```
┌─────────────────────────────────────────────────┐
│  Terminal Feedz - Main Menu                     │
│  ─────────────────────────────────────────────  │
│                                                 │
│  ▸ Browse Feeds                                 │
│    Manage Categories                            │
│    Manage Subscriptions                         │
│    Quit                                         │
└─────────────────────────────────────────────────┘
```

## Built With

- [Ruby](https://www.ruby-lang.org/) - Programming language
- [Feedjira](https://github.com/feedjira/feedjira) - RSS/Atom parser
- [TTY Toolkit](https://ttytoolkit.org/) - Terminal UI components
- [Nokogiri](https://nokogiri.org/) - HTML parsing
- [Rouge](https://github.com/rouge-ruby/rouge) - Syntax highlighting
- [Readability](https://github.com/cantino/ruby-readability) - Article extraction

## License

MIT License - see [LICENSE](LICENSE) for details.
