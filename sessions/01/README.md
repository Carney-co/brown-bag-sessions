# Developer Experience Setup Scripts 💃🕺

Automated setup scripts to transform your terminal into a powerful development environment, based on the "Improving your developer experience" presentation.

## 🎯 Overview

These scripts install and configure a curated set of developer tools to enhance your command-line experience with:

- 🚀 Modern shell with smart completions
- 🎨 Beautiful prompts and syntax highlighting
- 🔍 Fuzzy finding for files and history
- ⚡ Lightning-fast directory navigation
- 🛠️ Enhanced versions of common commands
- 💅 Beautiful fonts with programming ligatures

## 🖥️ Supported Platforms

### [macOS & Linux](./README-unix.md)

```bash
./install.sh
```

- Uses Homebrew as the package manager
- Configures zsh with powerful plugins
- Installs iTerm2 on macOS for a superior terminal experience

### [Windows](./README-windows.md)

```powershell
.\install-win.ps1
```

- Uses Scoop and WinGet as package managers
- Configures both PowerShell and Git Bash
- Includes Windows Terminal with Quake-style dropdown

## 🚀 Quick Start

### Unix/macOS/Linux

```bash
# Clone the repository
git clone <your-repo>
cd <your-repo>

# Make executable and run
chmod +x install.sh
./install.sh
```

### Windows

```powershell
# Clone the repository
git clone <your-repo>
cd <your-repo>

# Run as Administrator
.\install-win.ps1
```

## 📦 What You Get

| Tool         | Purpose                                      | All Platforms |
| ------------ | -------------------------------------------- | :-----------: |
| **Starship** | Beautiful, fast cross-shell prompt           |      ✅       |
| **fzf**      | Fuzzy finder for files, history, directories |      ✅       |
| **bat**      | Better `cat` with syntax highlighting        |      ✅       |
| **fd**       | Better `find` - faster and more intuitive    |      ✅       |
| **eza**      | Better `ls` with icons and git integration   |      ✅       |
| **z**        | Smart directory jumping                      |      ✅       |
| **hub**      | GitHub integration for git                   |      ✅       |
| **yazi**     | Terminal file manager                        |      ✅       |
| **FiraCode** | Programming font with ligatures              |      ✅       |

## 🎨 Supercharge your terminal

- 🎨 Color-coded file types and permissions
- 📁 Icons for different file types
- 🌿 Git status integration
- ⚡ Smart command suggestions
- 🔍 Fuzzy search through command history with `Ctrl+R`

## 🛠️ Customization

Both scripts are designed to be non-destructive:

- ✅ Existing configurations are backed up
- ✅ Tools are installed in user space (no system modifications)
- ✅ Easy to customize after installation
- ✅ Simple uninstallation process

## 📚 Documentation

- **[Unix/macOS/Linux Setup Guide](./README-unix.md)** - Detailed instructions for Unix-based systems
- **[Windows Setup Guide](./README-windows.md)** - Comprehensive guide for Windows users
- **[Original Presentation](./index.html)** - The reveal.js presentation these scripts are based on

## 🎤 Running the Presentation

This repository includes the original reveal.js presentation that inspired these scripts. To run it locally:

### Basic Setup (Static)

Simply open `index.html` in your web browser:

```bash
# macOS
open index.html

# Linux
xdg-open index.html

# Windows
start index.html
```

### Development Server (Recommended)

For the best experience with hot-reloading:

1. **Install dependencies:**

   ```bash
   npm install
   ```

2. **Start the development server:**

   ```bash
   npm start
   ```

3. **Open in your browser:**
   - Navigate to [http://localhost:8000](http://localhost:8000)
   - The presentation will reload automatically when you make changes

### Presentation Controls

- **Navigate:** Arrow keys or swipe on touch devices
- **Overview:** Press `Esc` or `O`
- **Speaker notes:** Press `S`
- **Fullscreen:** Press `F`
- **Zoom:** `Alt + Click` (Windows/Linux) or `Ctrl + Click` (macOS)

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest new tools or features
- 🔧 Submit pull requests
- 💬 Join the discussion on [Slack](https://carney.slack.com/archives/C08V05Y8F7D)

## ⚡ Next Steps

1. Choose your platform and run the appropriate script
2. Restart your terminal
3. Explore the new commands and features
4. Customize to your liking
5. You're now a rockstar ninja developer! 🥷🎸💻

---

_Remember: A good developer experience isn't just about productivity—it's about enjoying the time you spend in your terminal!_ 💃🕺
