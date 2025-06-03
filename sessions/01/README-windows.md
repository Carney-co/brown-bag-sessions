# Developer Experience Setup - Windows

A comprehensive PowerShell script to enhance your developer experience on Windows using Scoop and WinGet. Based on the "Improving your developer experience 💃🕺" presentation.

## 🚀 Quick Start

```powershell
# Run PowerShell as Administrator
# Download and run the script
Invoke-WebRequest -Uri https://raw.githubusercontent.com/your-repo/install-win.ps1 -OutFile install-win.ps1
.\install-win.ps1

# Or with WSL support
.\install-win.ps1 -UseWSL
```

## 📋 Prerequisites

- Windows 10 version 1903 or later (Windows 11 recommended)
- PowerShell 5.1 or later (comes with Windows)
- Administrator privileges (for some installations)
- Internet connection

## 🎯 What Gets Installed

### Package Managers

- **[Scoop](https://scoop.sh/)** - Command-line installer for Windows
- **[WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/)** - Used when available (Windows 11)

### Terminal & Shell

- **[Windows Terminal](https://github.com/microsoft/terminal)** - Modern terminal emulator
- **[windows-terminal-quake](https://github.com/flyingpie/windows-terminal-quake)** - Quake-style dropdown for Windows Terminal
- **Git Bash** - Unix-like shell experience on Windows

### Fonts

- **[FiraCode Nerd Font](https://github.com/tonsky/FiraCode)** - Programming font with ligatures and icons

### Command Line Tools

- **[Starship](https://starship.rs/)** - Fast, customizable cross-shell prompt
- **[fzf](https://github.com/junegunn/fzf)** - Fuzzy finder for files and history
- **[bat](https://github.com/sharkdp/bat)** - Better `cat` with syntax highlighting
- **[fd](https://github.com/sharkdp/fd)** - Better `find`
- **[eza](https://github.com/eza-community/eza)** - Better `ls` with icons and git integration
- **[hub](https://hub.github.com/)** - GitHub CLI tool that extends git
- **[yazi](https://github.com/sxyazi/yazi)** - Terminal file manager
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Better `grep`
- **[jq](https://stedolan.github.io/jq/)** - JSON processor

### PowerShell Modules

- **PSReadLine** - Enhanced command line editing with predictions
- **Terminal-Icons** - File and folder icons in terminal
- **z** - Directory jumping (like Unix z)
- **PSFzf** - FZF integration for PowerShell

## 🛠️ Configuration

The script automatically configures both PowerShell and Git Bash environments:

### PowerShell Profile

Location: `$PROFILE` (usually `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`)

Features configured:

- Starship prompt initialization
- PSReadLine with history-based predictions
- Terminal icons for file listings
- FZF key bindings (Ctrl+R for history, Ctrl+F for files)
- Custom aliases and functions
- Git shortcuts

### Git Bash Configuration

Location: `~\.bashrc`

Features configured:

- Starship prompt
- Unix-style aliases
- Enhanced history settings
- Git shortcuts

### Aliases and Functions

**PowerShell Aliases:**

```powershell
# File operations
l, ll, la    # Various ls shortcuts
cat          # Uses bat
find         # Uses fd
grep         # Uses ripgrep
ls           # Uses eza with icons

# Git shortcuts
gst          # git status
gco          # git checkout
gcob         # git checkout -b
ga           # git add
gc           # git commit
gp           # git push
gl           # git pull

# Navigation
..           # cd ..
...          # cd ../..
....         # cd ../../..
c            # Clear screen
```

**Special Functions:**

- `sysinfo` - Display system information
- `Edit-Profile` - Quick edit PowerShell profile
- `z <partial-path>` - Jump to frequently used directories

## 🔧 Windows-Specific Features

### Windows Terminal Quake Mode

After installation, you can use `wtq` command to launch a Quake-style dropdown terminal. Configure the hotkey in windows-terminal-quake settings.

### PowerShell Execution Policy

The script automatically sets the execution policy to `RemoteSigned` for the current user to allow script execution.

### Administrator Privileges

Some features require administrator privileges. The script will prompt for elevation when needed.

## 📝 Post-Installation Steps

1. **Restart Windows Terminal** to load all configurations

2. **Configure Windows Terminal**:

   - Open Windows Terminal settings (Ctrl+,)
   - Set FiraCode Nerd Font as default font
   - Choose your preferred color scheme
   - Configure windows-terminal-quake hotkey

3. **Test the installation**:

   ```powershell
   # Test Starship prompt
   starship --version

   # Test fzf
   echo "test" | fzf

   # Test enhanced commands
   ls  # Should show files with icons
   cat README.md  # Should show syntax highlighting

   # Test directory jumping
   z <partial-directory-name>
   ```

4. **Optional: Set up WSL**:

   ```powershell
   # Install WSL
   wsl --install

   # Then run the Unix install script inside WSL
   ```

## ⚙️ Customization

### Starship Prompt

Create `~\.config\starship.toml` to customize your prompt. See [Starship docs](https://starship.rs/config/).

### Windows Terminal Settings

Access via `Ctrl+,` in Windows Terminal to customize:

- Color schemes
- Font settings
- Key bindings
- Profiles

### PowerShell Profile

Edit your profile with:

```powershell
Edit-Profile  # or notepad $PROFILE
```

## 🔍 Troubleshooting

### "cannot be loaded because running scripts is disabled"

The script sets execution policy automatically, but if you still see this:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "scoop/winget is not recognized"

- Restart PowerShell after installation
- Ensure Scoop is in PATH: `$env:Path`

### Fonts not displaying correctly

- Restart Windows Terminal after font installation
- Manually select FiraCode Nerd Font in Terminal settings
- Some applications may need a system restart

### Module installation fails

Run PowerShell as Administrator and retry:

```powershell
Install-Module -Name <ModuleName> -Force -AllowClobber
```

### Git Bash not configured

Ensure Git is installed via Scoop:

```powershell
scoop install git
```

## 🔄 Updating

To update installed tools:

```powershell
# Update Scoop and all packages
scoop update *

# Update PowerShell modules
Update-Module

# Update WinGet packages (if using WinGet)
winget upgrade --all
```

## 🗑️ Uninstallation

The script creates backups of existing configurations. To revert:

```powershell
# Restore original PowerShell profile
$backupFile = Get-ChildItem "$PROFILE.backup.*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($backupFile) { Copy-Item $backupFile.FullName $PROFILE -Force }

# Uninstall Scoop packages
scoop uninstall *

# Remove PowerShell modules
Get-Module -ListAvailable PSReadLine, Terminal-Icons, z, PSFzf | Uninstall-Module

# Uninstall Scoop itself
scoop uninstall scoop
```

## 🐧 WSL Integration

For the full Linux development experience on Windows:

1. Install WSL:

   ```powershell
   wsl --install
   ```

2. Run the Unix install script inside WSL:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/your-repo/install.sh | bash
   ```

3. Access WSL from Windows Terminal - it automatically creates a profile

## 📚 Additional Resources

- [Scoop Documentation](https://scoop.sh/)
- [Windows Terminal Documentation](https://docs.microsoft.com/en-us/windows/terminal/)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

## 🤝 Contributing

Feel free to submit issues or pull requests to improve the installation script!

## 📄 License

This script is provided as-is for educational purposes based on the developer experience presentation.

## ⚠️ Security Note

This script requires administrator privileges for some operations. Always review scripts before running them with elevated privileges. The script will:

- Install software from official sources via Scoop/WinGet
- Modify your PowerShell profile
- Create backup files of existing configurations
