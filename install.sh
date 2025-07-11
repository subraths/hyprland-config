#!/usr/bin/env bash

# Hyprland Configuration Installation Script
# This script helps you install and configure the Hyprland setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root"
    exit 1
fi

print_status "Starting Hyprland configuration installation..."

# Create backup if existing configuration exists
HYPR_CONFIG_DIR="$HOME/.config/hypr"
if [ -d "$HYPR_CONFIG_DIR" ]; then
    BACKUP_DIR="$HYPR_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Existing Hyprland configuration found"
    print_status "Creating backup at: $BACKUP_DIR"
    mv "$HYPR_CONFIG_DIR" "$BACKUP_DIR"
    print_success "Backup created successfully"
fi

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy configuration files
print_status "Copying configuration files..."
cp -r "$SCRIPT_DIR" "$HYPR_CONFIG_DIR"

# Remove the install script from the destination
rm -f "$HYPR_CONFIG_DIR/install.sh"

# Make scripts executable
print_status "Setting script permissions..."
chmod +x "$HYPR_CONFIG_DIR"/scripts/*.sh

print_success "Configuration files copied successfully"

# Check for required dependencies
print_status "Checking for required dependencies..."

MISSING_DEPS=()
REQUIRED_DEPS=(
    "hyprland"
    "hyprlock" 
    "hyprpaper"
    "hypridle"
    "waybar"
    "kitty"
    "rofi"
    "mako"
    "grim"
    "slurp"
    "brightnessctl"
)

for dep in "${REQUIRED_DEPS[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    print_warning "The following required dependencies are missing:"
    for dep in "${MISSING_DEPS[@]}"; do
        echo "  - $dep"
    done
    echo ""
    print_status "Please install these packages using your distribution's package manager"
else
    print_success "All required dependencies are installed"
fi

# Check for optional dependencies
print_status "Checking for optional dependencies..."

OPTIONAL_DEPS=(
    "thunar"
    "zen-browser"
    "firefox"
    "blueman-manager"
    "udiskie"
    "lxsession"
    "wpctl"
)

MISSING_OPTIONAL=()
for dep in "${OPTIONAL_DEPS[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        MISSING_OPTIONAL+=("$dep")
    fi
done

if [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
    print_status "Optional dependencies that could be installed:"
    for dep in "${MISSING_OPTIONAL[@]}"; do
        echo "  - $dep"
    done
fi

# Setup wallpaper directory
print_status "Setting up wallpaper directory..."
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
mkdir -p "$WALLPAPER_DIR"

if [ ! -f "$WALLPAPER_DIR/wallpaper1.jpg" ] && [ ! -f "$WALLPAPER_DIR/lockscreen.jpg" ]; then
    print_warning "No wallpaper images found in $WALLPAPER_DIR"
    print_status "Please add your wallpaper images to:"
    echo "  - $WALLPAPER_DIR/wallpaper1.jpg (main wallpaper)"
    echo "  - $WALLPAPER_DIR/wallpaper2.jpg (secondary monitor wallpaper)"
    echo "  - $WALLPAPER_DIR/lockscreen.jpg (lock screen wallpaper)"
fi

# Final instructions
echo ""
print_success "Installation completed successfully!"
echo ""
print_status "Next steps:"
echo "1. Install any missing dependencies shown above"
echo "2. Add wallpaper images to $WALLPAPER_DIR/"
echo "3. Review and customize the configuration files in $HYPR_CONFIG_DIR"
echo "4. Log out and select Hyprland from your display manager"
echo ""
print_status "Key files to customize:"
echo "  - hyprland.conf: Main configuration (applications, monitor setup)"
echo "  - keybinds.conf: Keyboard shortcuts" 
echo "  - hyprpaper.conf: Wallpaper settings"
echo "  - hyprlock.conf: Lock screen appearance"
echo ""
print_status "For help and documentation, see: $HYPR_CONFIG_DIR/README.md"