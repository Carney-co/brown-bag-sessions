# Developer Experience Setup Script for Windows
# Based on the "Improving your developer experience" presentation
# This script installs and configures various developer tools using Scoop and WinGet

# Require elevated privileges for some installations
#Requires -RunAsAdministrator

param(
    [switch]$UseWSL = $false
)

# Set execution policy if needed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

Write-Host "🚀 Starting Developer Experience Setup for Windows..." -ForegroundColor Green

# Colors for output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Header {
    param([string]$Message)
    Write-Host "`n=== $Message ===`n" -ForegroundColor Blue
}

# Check Windows version
$WindowsVersion = [System.Environment]::OSVersion.Version
Write-Status "Windows Version: $($WindowsVersion.Major).$($WindowsVersion.Minor)"

# Install Scoop if not already installed
Write-Header "Installing Scoop Package Manager 🍨"
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Status "Installing Scoop..."
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    Write-Status "Scoop installed ✅"
} else {
    Write-Status "Scoop is already installed ✅"
}

# Update Scoop
Write-Header "Updating Scoop"
scoop update

# Add essential buckets
Write-Status "Adding Scoop buckets..."
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add versions

# Check if WinGet is available (Windows 11 or manually installed)
$WinGetAvailable = $false
if (Get-Command winget -ErrorAction SilentlyContinue) {
    $WinGetAvailable = $true
    Write-Status "WinGet is available ✅"
} else {
    Write-Warning "WinGet is not available. Some installations will use Scoop instead."
}

# Install Windows Terminal and Quake mode
Write-Header "Installing Terminal Emulator 💻"
if ($WinGetAvailable) {
    try {
        winget install Microsoft.WindowsTerminal --silent --accept-source-agreements --accept-package-agreements
        Write-Status "Windows Terminal installed via WinGet ✅"
    } catch {
        Write-Warning "Failed to install via WinGet, trying Scoop..."
        scoop install windows-terminal
    }
} else {
    scoop install windows-terminal
    Write-Status "Windows Terminal installed via Scoop ✅"
}

# Install windows-terminal-quake
Write-Status "Installing windows-terminal-quake..."
if ($WinGetAvailable) {
    try {
        winget install flyingpie.windows-terminal-quake --silent --accept-source-agreements --accept-package-agreements
        Write-Status "windows-terminal-quake installed via WinGet ✅"
    } catch {
        scoop install windows-terminal-quake
        Write-Status "windows-terminal-quake installed via Scoop ✅"
    }
} else {
    scoop install windows-terminal-quake
    Write-Status "windows-terminal-quake installed via Scoop ✅"
}

# Install fonts
Write-Header "Installing Fonts 🔡"
try {
    scoop install FiraCode-NF
    Write-Status "FiraCode Nerd Font installed ✅"
} catch {
    Write-Warning "Font installation failed. You can install manually from: https://github.com/ryanoasis/nerd-fonts/releases"
}

# Install Git and Git Bash
Write-Header "Installing Git and Git Bash 🌐"
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    scoop install git
    Write-Status "Git installed ✅"
} else {
    Write-Status "Git is already installed ✅"
}

# Install essential command line tools
Write-Header "Installing Command Line Tools 🔧"

$tools = @(
    "starship",      # Cross-shell prompt
    "fzf",           # Fuzzy finder
    "bat",           # Better cat
    "fd",            # Better find
    "eza",           # Better ls
    "hub",           # Better git
    "less",          # Pager
    "yazi",          # Terminal file manager
    "ripgrep",       # Better grep
    "jq"             # JSON processor
)

foreach ($tool in $tools) {
    if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
        try {
            scoop install $tool
            Write-Status "$tool installed ✅"
        } catch {
            Write-Warning "Failed to install $tool"
        }
    } else {
        Write-Status "$tool is already installed ✅"
    }
}

# Install PowerShell modules for enhanced experience
Write-Header "Installing PowerShell Modules 🔧"

$modules = @(
    "PSReadLine",           # Enhanced command line editing
    "Terminal-Icons",       # File icons in terminal
    "z",                   # Directory jumping
    "PSFzf"                # FZF integration for PowerShell
)

foreach ($module in $modules) {
    if (!(Get-Module -ListAvailable -Name $module)) {
        try {
            Install-Module -Name $module -Force -AllowClobber -Scope CurrentUser
            Write-Status "PowerShell module $module installed ✅"
        } catch {
            Write-Warning "Failed to install PowerShell module $module"
        }
    } else {
        Write-Status "PowerShell module $module is already installed ✅"
    }
}

# Configure PowerShell Profile
Write-Header "Configuring PowerShell Profile 🛠️"

$ProfilePath = $PROFILE.CurrentUserAllHosts
$ProfileDir = Split-Path -Parent $ProfilePath

# Create profile directory if it doesn't exist
if (!(Test-Path -Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force
}

# Backup existing profile
if (Test-Path -Path $ProfilePath) {
    $BackupPath = "$ProfilePath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item -Path $ProfilePath -Destination $BackupPath -Force
    Write-Status "Backed up existing PowerShell profile ✅"
}

# Create enhanced PowerShell profile
$ProfileContent = @'
# Enhanced PowerShell Profile for Developer Experience

# Import modules
Import-Module PSReadLine
Import-Module Terminal-Icons
Import-Module z
Import-Module PSFzf

# PSReadLine configuration
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Key Ctrl+f -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+b -Function BackwardWord

# FZF configuration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Starship prompt
Invoke-Expression (&starship init powershell)

# Useful aliases
Set-Alias -Name l -Value Get-ChildItem
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name la -Value Get-ChildItem
Set-Alias -Name cat -Value bat
Set-Alias -Name find -Value fd
Set-Alias -Name grep -Value rg

# Enhanced ls with eza
function Get-ChildItemPretty { eza --long --all --git --icons $args }
Set-Alias -Name ls -Value Get-ChildItemPretty -Force

# Git aliases
function gst { git status $args }
function gco { git checkout $args }
function gcob { git checkout -b $args }
function ga { git add $args }
function gc { git commit $args }
function gp { git push $args }
function gl { git pull $args }

# Quick directory navigation
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }

# Clear screen shortcut
function c { Clear-Host }

# Show system information
function sysinfo {
    Write-Host "System Information:" -ForegroundColor Green
    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory
}

# Quick edit profile
function Edit-Profile { notepad $PROFILE }

Write-Host "🚀 Enhanced PowerShell profile loaded!" -ForegroundColor Green
'@

# Write the profile content
$ProfileContent | Out-File -FilePath $ProfilePath -Encoding UTF8 -Force
Write-Status "PowerShell profile configured ✅"

# Configure Git Bash (if available)
Write-Header "Configuring Git Bash 🐚"
$GitBashProfile = "$env:USERPROFILE\.bashrc"

if (Test-Path -Path "$(scoop prefix git)\bin\bash.exe") {
    # Backup existing .bashrc
    if (Test-Path -Path $GitBashProfile) {
        $BackupPath = "$GitBashProfile.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item -Path $GitBashProfile -Destination $BackupPath -Force
        Write-Status "Backed up existing .bashrc ✅"
    }
    
    $BashrcContent = @'
# Enhanced Git Bash configuration

# Starship prompt
eval "$(starship init bash)"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias cat='bat'
alias find='fd'
alias grep='rg'

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias gcob='git checkout -b'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# History settings
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups

# FZF settings
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

echo "🚀 Enhanced Git Bash profile loaded!"
'@
    
    $BashrcContent | Out-File -FilePath $GitBashProfile -Encoding UTF8 -Force
    Write-Status "Git Bash profile configured ✅"
}

# WSL Configuration (if requested)
if ($UseWSL) {
    Write-Header "WSL Configuration 🐧"
    
    # Check if WSL is installed
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        Write-Status "WSL is available. You can run the Linux install script inside WSL:"
        Write-Status "  1. Open WSL: wsl"
        Write-Status "  2. Run: curl -fsSL https://raw.githubusercontent.com/your-repo/install.sh | bash"
        Write-Status "  3. Or download and run the install.sh script"
    } else {
        Write-Warning "WSL is not installed. You can install it with:"
        Write-Warning "  wsl --install"
        Write-Warning "Then restart and run this script with -UseWSL flag"
    }
}

# Final setup and information
Write-Header "🎉 Installation Complete!"
Write-Host ""
Write-Status "All tools have been installed and configured!"
Write-Warning "Please restart PowerShell or Windows Terminal to apply all changes."

if (Test-Path -Path "$(scoop prefix windows-terminal-quake)\wtq.exe") {
    Write-Status "You can now use 'wtq' command to launch quake-style terminal!"
}

Write-Host ""
Write-Host "Installed tools:" -ForegroundColor Green
Write-Host "  📱 Windows Terminal - Modern terminal emulator" -ForegroundColor White
Write-Host "  ⚡ windows-terminal-quake - Quake-style dropdown terminal" -ForegroundColor White
Write-Host "  🔡 FiraCode Nerd Font - Programming font with ligatures" -ForegroundColor White
Write-Host "  🚀 Starship - Cross-shell prompt" -ForegroundColor White
Write-Host "  🔍 fzf - Fuzzy finder" -ForegroundColor White
Write-Host "  🦇 bat - Better cat with syntax highlighting" -ForegroundColor White
Write-Host "  🔎 fd - Better find" -ForegroundColor White
Write-Host "  📋 eza - Better ls with icons" -ForegroundColor White
Write-Host "  🌐 hub - Better git" -ForegroundColor White
Write-Host "  📁 yazi - Terminal file manager" -ForegroundColor White
Write-Host "  🔧 Enhanced PowerShell modules and configuration" -ForegroundColor White

Write-Host ""
Write-Status "Next steps:"
Write-Status "  1. Restart your terminal"
Write-Status "  2. Try the new commands and aliases"
Write-Status "  3. Customize your Windows Terminal settings"
Write-Status "  4. Consider using WSL for the full Linux development experience"

Write-Host ""
Write-Status "Enjoy your enhanced developer experience on Windows! 💃🕺" -ForegroundColor Green 