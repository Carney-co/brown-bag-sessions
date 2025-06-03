# Developer Experience Setup - Unix/macOS/Linux

A comprehensive installation script to enhance your developer experience on Unix-based systems (macOS and Linux) using Homebrew. Based on the "Improving your developer experience 💃🕺" presentation.

## 🚀 Quick Start

```bash
# Download and run the script
curl -fsSL https://raw.githubusercontent.com/your-repo/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

Or clone and run locally:

```bash
git clone <your-repo>
cd <your-repo>
./install.sh
```

## 📋 Prerequisites

### macOS

- macOS 10.13 or later
- Command Line Tools for Xcode (will be installed automatically with Homebrew)

### Linux

- A 64-bit Linux distribution
- `curl` or `wget` installed
- `git` installed (for some components)
- sudo access (for system package manager operations)

## 🎯 What Gets Installed

### Package Manager

- **[Homebrew](https://brew.sh/)** - The missing package manager for macOS (and Linux)

### Terminal & Shell

- **[iTerm2](https://iterm2.com/)** (macOS only) - Advanced terminal emulator with Quake-style dropdown
- **[zsh](https://www.zsh.org/)** - Modern shell with advanced features
- **[Starship](https://starship.rs/)** - Fast, customizable cross-shell prompt

### Fonts

- **[FiraCode Nerd Font](https://github.com/tonsky/FiraCode)** - Programming font with ligatures and icons

### Shell Enhancements

- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** - Fish-like autosuggestions for zsh
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** - Syntax highlighting for commands
- **[z](https://github.com/rupa/z)** - Jump to frequently used directories
- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder for files, history, and more
- **[scm_breeze](https://github.com/scmbreeze/scm_breeze)** - Git workflow shortcuts

### Command Line Tools

- **[bat](https://github.com/sharkdp/bat)** - Better `cat` with syntax highlighting
- **[fd](https://github.com/sharkdp/fd)** - Better `find`
- **[eza](https://github.com/eza-community/eza)** - Better `ls` with icons and git integration
- **[hub](https://hub.github.com/)** - GitHub CLI tool that extends git
- **[lesspipe](https://github.com/wofr06/lesspipe)** - Enhanced `less` command
- **[yazi](https://github.com/sxyazi/yazi)** - Terminal file manager
- **[sl](https://github.com/mtoyoda/sl)** - Steam locomotive (typo correction fun)

## 🛠️ Configuration

The script automatically configures your shell environment with:

### Shell Configuration (`~/.zshrc`)

- Starship prompt initialization
- Shell plugin sourcing
- Enhanced history settings
- Auto-cd functionality
- Custom aliases and functions
- FZF integration

### FZF Configuration (`~/.zprofile`)

- Custom FZF options for better usability
- Preview windows for file browsing
- Keyboard shortcuts (Ctrl+R for history, Ctrl+T for files)
- Integration with bat for syntax-highlighted previews

### Aliases Added

```bash
alias "?"="pwd"              # Quick current directory
alias c="clear"              # Clear screen
alias git="hub"              # Enhanced git
alias gcob="gco -b"          # Git checkout new branch
alias y="yarn"               # Yarn shortcut
alias fd="fd --hidden"       # Find including hidden files
alias l="eza --long --all --git --icons"  # Enhanced ls
alias cat="bat"              # Better cat
```

### Custom Functions

- `z <partial-path>` - Jump to frequently used directories
- `zz` - Interactive directory jumping with fzf
- Git shortcuts via scm_breeze (e.g., `gs` for status, `ga` for add)

## 🔧 Platform-Specific Notes

### macOS

- iTerm2 is installed as the terminal emulator
- Fonts are installed via Homebrew casks
- Works on both Intel and Apple Silicon Macs

### Linux

- Terminal emulator suggestions are provided (Guake, Yakuake, Tilda)
- Fonts need manual installation:
  1. Download from [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases)
  2. Extract to `~/.local/share/fonts/`
  3. Run `fc-cache -fv`
- zsh installation attempts to use system package manager first

## 📝 Post-Installation Steps

1. **Restart your terminal** or run:

   ```bash
   source ~/.zshrc
   ```

2. **Set zsh as default shell** (if not already):

   ```bash
   chsh -s $(which zsh)
   ```

3. **Configure your terminal**:

   - Set FiraCode Nerd Font as your terminal font
   - Import terminal theme/colors of your choice
   - Configure hotkeys for dropdown terminal (macOS: iTerm2, Linux: your chosen terminal)

4. **Test the installation**:

   ```bash
   # Test starship prompt
   starship --version

   # Test fzf
   echo "test" | fzf

   # Test enhanced commands
   l  # Should show files with icons
   cat README.md  # Should show syntax highlighting
   ```

## ⚙️ Customization

### Starship Prompt

Create `~/.config/starship.toml` to customize your prompt. See [Starship docs](https://starship.rs/config/).

### FZF Options

Edit the FZF options in `~/.zprofile` to customize fuzzy finder behavior.

### Additional Aliases

Add your own aliases to `~/.zshrc` after the script-generated content.

## 🔍 Troubleshooting

### "Command not found" after installation

- Restart your terminal or run `source ~/.zshrc`
- Ensure Homebrew is in your PATH

### Fonts not displaying correctly

- Make sure to select FiraCode Nerd Font in your terminal settings
- On Linux, ensure fonts are properly installed in `~/.local/share/fonts/`

### Permission issues

- The script should not require sudo on macOS
- On Linux, sudo may be needed for system package manager operations

### Homebrew installation fails

- Ensure you have Xcode Command Line Tools (macOS): `xcode-select --install`
- Check internet connectivity
- See [Homebrew troubleshooting](https://docs.brew.sh/Troubleshooting)

## 🔄 Updating

To update installed tools:

```bash
# Update Homebrew and all packages
brew update && brew upgrade

# Update scm_breeze
cd ~/.scm_breeze && git pull
```

## 🗑️ Uninstallation

The script creates backups of existing configurations. To revert:

```bash
# Restore original configs (check for backup files)
mv ~/.zshrc.backup.<timestamp> ~/.zshrc
mv ~/.zprofile.backup.<timestamp> ~/.zprofile

# Uninstall Homebrew packages
brew list | xargs brew uninstall --force

# Remove scm_breeze
rm -rf ~/.scm_breeze
```

## 📚 Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Zsh Documentation](https://zsh.sourceforge.io/Doc/)
- [Starship Configuration](https://starship.rs/config/)
- [FZF Wiki](https://github.com/junegunn/fzf/wiki)

## 🤝 Contributing

Feel free to submit issues or pull requests to improve the installation script!

## 📄 License

This script is provided as-is for educational purposes based on the developer experience presentation.
