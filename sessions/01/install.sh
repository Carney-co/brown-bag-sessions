#!/bin/bash

# Developer Experience Setup Script
# Based on the "Improving your developer experience" presentation
# This script installs and configures various developer tools using Homebrew

set -e  # Exit on any error

echo "🚀 Starting Developer Experience Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Detect OS
OS="Unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
fi

print_status "Detected OS: $OS"

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    print_header "Installing Homebrew 🍺"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ "$OS" == "macOS" && $(uname -m) == "arm64" ]]; then
        # Apple Silicon Mac
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ "$OS" == "Linux" ]]; then
        # Linux
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    print_status "Homebrew is already installed ✅"
fi

# Update Homebrew
print_header "Updating Homebrew"
brew update

# Install terminal emulator (platform specific)
print_header "Installing Terminal Emulator 💻"
if [[ "$OS" == "macOS" ]]; then
    if ! brew list --cask iterm2 &> /dev/null; then
        brew install --cask iterm2
        print_status "iTerm2 installed ✅"
    else
        print_status "iTerm2 is already installed ✅"
    fi
elif [[ "$OS" == "Linux" ]]; then
    print_status "For Linux, consider installing a dropdown terminal:"
    print_status "  - Guake: sudo apt install guake"
    print_status "  - Yakuake: sudo apt install yakuake (KDE)"
    print_status "  - Tilda: sudo apt install tilda"
fi

# Install fonts
print_header "Installing Fonts 🔡"
if [[ "$OS" == "macOS" ]]; then
    brew tap homebrew/cask-fonts
    if ! brew list --cask font-fira-code-nerd-font &> /dev/null; then
        brew install --cask font-fira-code-nerd-font
        print_status "FiraCode Nerd Font installed ✅"
    else
        print_status "FiraCode Nerd Font is already installed ✅"
    fi
elif [[ "$OS" == "Linux" ]]; then
    print_status "For Linux, you can install fonts manually:"
    print_status "  1. Download FiraCode Nerd Font from: https://github.com/ryanoasis/nerd-fonts/releases"
    print_status "  2. Extract to ~/.local/share/fonts/"
    print_status "  3. Run: fc-cache -fv"
    print_warning "Font installation on Linux requires manual steps ⚠️"
fi

# Install shell (zsh is default on macOS, but let's make sure)
print_header "Setting up Shell 🐚"
if ! command -v zsh &> /dev/null; then
    if [[ "$OS" == "Linux" ]]; then
        # On Linux, try to install zsh via system package manager first
        if command -v apt &> /dev/null; then
            print_status "Installing zsh via apt..."
            sudo apt update && sudo apt install -y zsh
        elif command -v yum &> /dev/null; then
            print_status "Installing zsh via yum..."
            sudo yum install -y zsh
        elif command -v dnf &> /dev/null; then
            print_status "Installing zsh via dnf..."
            sudo dnf install -y zsh
        else
            # Fallback to Homebrew
            brew install zsh
        fi
    else
        brew install zsh
    fi
    print_status "zsh installed ✅"
else
    print_status "zsh is already installed ✅"
fi

# Install prompt
print_header "Installing Starship Prompt 🚀"
if ! command -v starship &> /dev/null; then
    brew install starship
    print_status "Starship installed ✅"
else
    print_status "Starship is already installed ✅"
fi

# Install shell plugins and tools
print_header "Installing Shell Plugins and Tools 🔧"

# Install zsh plugins
tools=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "z"
    "fzf"
    "bat"
    "fd"
    "eza"
    "hub"
    "lesspipe"
    "yazi"
    "sl"
)

for tool in "${tools[@]}"; do
    if ! brew list "$tool" &> /dev/null; then
        brew install "$tool"
        print_status "$tool installed ✅"
    else
        print_status "$tool is already installed ✅"
    fi
done

# Install scm_breeze (not available via brew, needs git clone)
print_header "Installing scm_breeze 🌊"
if [[ ! -d ~/.scm_breeze ]]; then
    git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
    ~/.scm_breeze/install.sh
    print_status "scm_breeze installed ✅"
else
    print_status "scm_breeze is already installed ✅"
fi

# Configure shell
print_header "Configuring Shell 🛠️"

# Backup existing configs
if [[ -f ~/.zshrc ]]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    print_status "Backed up existing .zshrc ✅"
fi

if [[ -f ~/.zprofile ]]; then
    cp ~/.zprofile ~/.zprofile.backup.$(date +%Y%m%d_%H%M%S)
    print_status "Backed up existing .zprofile ✅"
fi

# Add starship to shell config
if ! grep -q "starship init zsh" ~/.zshrc 2>/dev/null; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
    print_status "Added Starship to .zshrc ✅"
fi

# Add shell plugins to .zshrc
cat >> ~/.zshrc << 'EOF'

# Shell plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/etc/profile.d/z.sh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# scm_breeze
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

# Enable auto-cd
setopt AUTO_CD

# limit of history entries
HISTORY_IGNORE='(clear|c|pwd|exit|* —help|[bf]g *|less *|cd ..|cd -)'

# History options
setopt BANG_HIST                 # Perform textual history expansion, csh-style, treating the character '!' specially.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from each command line being added to the history list.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands
setopt HIST_NO_FUNCTIONS         # Don't store function definitions
setopt HIST_SAVE_BY_COPY         # When writing out a copy of the history file, zsh preserves the old file's permissions and group information

# NOTE: must come before zsh-history-substring-search & zsh-syntax-highlighting.
autoload -U select-word-style
# only alphanumeric chars are considered WORDCHARS
select-word-style bash

## FZF Functions
# https://github.com/junegunn/fzf/wiki/Examples#z
unalias z 2>/dev/null || true
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

zz() {
  cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q $_last_z_args)"
}

# Useful aliases
alias "?"="pwd"
alias c="clear "
alias git="hub "
alias gcob="gco -b "
alias y="yarn"
alias fd="fd --hidden "
alias l="eza --long --all --git --icons"
alias cat='bat '

EOF

# Add FZF configuration to .zprofile (with platform-aware paths)
BREW_PREFIX=$(brew --prefix)
cat >> ~/.zprofile << EOF

# FZF Options
export FZF_DEFAULT_OPTS='--reverse --extended --tabstop=2 --margin 1 --height 40%'
export FZF_CTRL_T_COMMAND="${BREW_PREFIX}/bin/fd --strip-cwd-prefix --hidden --follow --no-ignore-vcs";
export FZF_DEFAULT_COMMAND="\${FZF_CTRL_T_COMMAND} --type f";
# https://github.com/sharkdp/bat/issues/634#issuecomment-524525661
export FZF_PREVIEW_COMMAND="COLORTERM=truecolor previewer {}";
export FZF_ALT_C_COMMAND="\${FZF_CTRL_T_COMMAND} --type d .";
export FZF_DEFAULT_OPTS="--border thinblock --prompt='» ' --pointer='▶' --marker='✓ ' --reverse --tabstop 2 --multi --color=bg+:-1,marker:010 --separator='' --bind '?:toggle-preview' --info inline-right";
export FZF_CTRL_T_OPTS="--preview-window right:border-left:60%:hidden --preview='(\${FZF_PREVIEW_COMMAND})' --walker-skip .git,node_modules";
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap:hidden --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard'";
export FZF_ALT_C_OPTS="--preview='(\${FZF_PREVIEW_COMMAND}) 2> /dev/null' --walker-skip .git,node_modules";

EOF

print_status "Shell configuration added ✅"

# Install FZF key bindings
print_header "Setting up FZF key bindings"
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

print_header "🎉 Installation Complete!"
echo
print_status "All tools have been installed and configured!"
print_warning "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."

if [[ "$OS" == "Linux" ]]; then
    print_warning "On Linux, you may need to:"
    print_warning "  1. Install fonts manually (see instructions above)"
    print_warning "  2. Install a dropdown terminal emulator (guake, yakuake, tilda)"
    print_warning "  3. Set zsh as your default shell: chsh -s \$(which zsh)"
fi

echo
echo "Installed tools:"
if [[ "$OS" == "macOS" ]]; then
    echo "  📱 iTerm2 - Advanced terminal emulator"
    echo "  🔡 FiraCode Nerd Font - Programming font with ligatures"
else
    echo "  🔡 Font installation instructions provided above"
    echo "  📱 Terminal emulator suggestions provided above"
fi
echo "  🚀 Starship - Cross-shell prompt"
echo "  🔧 zsh-autosuggestions - Fish-like autosuggestions"
echo "  🎨 zsh-syntax-highlighting - Syntax highlighting"
echo "  📂 z - Jump to frequently used directories"
echo "  🔍 fzf - Fuzzy finder"
echo "  🦇 bat - Better cat with syntax highlighting"
echo "  🔎 fd - Better find"
echo "  📋 eza - Better ls"
echo "  🌐 hub - Better git"
echo "  📄 lesspipe - Better less"
echo "  📁 yazi - Terminal file manager"
echo "  🚂 sl - Fun steam locomotive"
echo "  🌊 scm_breeze - Git shortcuts"
echo
print_status "Enjoy your enhanced developer experience! 💃🕺" 