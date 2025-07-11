# Hyprland Configuration

A comprehensive Hyprland window manager configuration featuring a minimal, functional setup with essential utilities and keybindings.

## Features

- **Clean minimal design** with optional rounded corners and blur effects
- **Comprehensive keybindings** using ALT as the main modifier
- **System utility scripts** for volume, brightness, and system control
- **Multiple monitor support** with mirroring configuration
- **Auto-starting applications** including waybar, notifications, and system services
- **Screen lock and wallpaper management** via hyprlock and hyprpaper
- **Bluetooth and WiFi management shortcuts**

## Prerequisites

Before using this configuration, ensure you have the following installed:

### Required Packages
- `hyprland` - The Wayland compositor
- `hyprlock` - Screen locker for Hyprland
- `hyprpaper` - Wallpaper utility for Hyprland
- `hypridle` - Idle daemon for Hyprland
- `hyprsunset` - Blue light filter
- `waybar` - Status bar
- `kitty` - Terminal emulator (configurable)
- `thunar` - File manager (configurable)
- `rofi` - Application launcher
- `mako` - Notification daemon
- `grim` - Screenshot utility
- `slurp` - Screen area selection tool
- `brightnessctl` - Brightness control
- `wpctl` (pipewire-pulse) - Audio control

### Optional Packages
- `zen-browser` - Web browser (configurable)
- `blueman-manager` - Bluetooth management GUI
- `udiskie` - Automatic mounting of removable media
- `lxsession` - Session manager
- `gnome-keyring` - Credential storage

## Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/subraths/hyprland-config.git
   cd hyprland-config
   ```

2. **Backup existing configuration (if any):**
   ```bash
   mv ~/.config/hypr ~/.config/hypr.backup
   ```

3. **Copy configuration files:**
   ```bash
   mkdir -p ~/.config/hypr
   cp -r * ~/.config/hypr/
   ```

4. **Make scripts executable:**
   ```bash
   chmod +x ~/.config/hypr/scripts/*.sh
   ```

5. **Update wallpaper paths:**
   Edit `hyprpaper.conf` and `hyprlock.conf` to point to your wallpaper images:
   ```bash
   # Replace /home/subrath/Pictures/wallpapers/ with your wallpaper directory
   sed -i 's|/home/subrath/Pictures/wallpapers/|/path/to/your/wallpapers/|g' hyprpaper.conf hyprlock.conf
   ```

## Configuration Files

- **`hyprland.conf`** - Main Hyprland configuration
- **`keybinds.conf`** - Keyboard shortcuts and bindings
- **`hyprlock.conf`** - Screen lock appearance and behavior
- **`hyprpaper.conf`** - Wallpaper settings for different monitors
- **`hypridle.conf`** - Idle timeout actions (currently minimal)
- **`hyprsunset.conf`** - Blue light filter settings (currently minimal)

## Key Bindings

### Window Management
- `ALT + Enter` - Open terminal (kitty)
- `ALT + Q` - Close active window
- `ALT + Shift + Q` - Exit Hyprland
- `ALT + V` - Toggle floating mode
- `ALT + F` - Toggle fullscreen
- `ALT + P` - Open application launcher (rofi)

### Navigation
- `ALT + H/J/K/L` - Move focus (Vim-style)
- `ALT + 1-9` - Switch to workspace 1-9
- `ALT + Shift + 1-9` - Move window to workspace 1-9
- `ALT + Tab` - Focus current or last window
- `ALT + \`` - Switch to previous workspace

### Applications
- `ALT + Shift + Enter` - Open file manager (thunar)
- `ALT + Shift + B` - Open browser (zen-browser)
- `ALT + Shift + Z` - Open PDF viewer (zathura)
- `ALT + Shift + Y` - Open file manager in terminal (yazi)

### System Controls
- `F1/F2/F3` - Volume down/up/mute
- `F11/F12` - Brightness down/up
- `Shift + F11/F12` - Color temperature down/up
- `F9` - Screenshot selection
- `F10` - Full screenshot
- `ALT + Shift + L` - Lock screen

### Bluetooth & Network
- `ALT + Shift + M` - Connect Bluetooth device
- `ALT + Shift + L` - Disconnect Bluetooth device  
- `ALT + Shift + S` - WiFi connection script

## Utility Scripts

The `scripts/` directory contains various utility scripts:

- **`volume.sh`** - Volume control with notification support
- **`brightness.sh`** - Screen brightness control
- **`temperature.sh`** - Color temperature adjustment
- **`waybar-starter.sh`** - Waybar startup script
- **`resetxdgportal.sh`** - Fixes XDG portal for screen sharing
- **`bat-notify.sh`** - Battery status notifications
- **`gtk_theme_picker.sh`** - GTK theme selection
- **`connect-wifi.sh`** - WiFi connection helper
- **`connect-bluetooth.sh`** - Bluetooth connection helper

## Customization

### Changing the Terminal or Applications
Edit the variables at the top of `hyprland.conf`:
```
$terminal = your-terminal
$fileManager = your-file-manager
$browser = your-browser
```

### Monitor Configuration
Adjust monitor settings in `hyprland.conf`:
```
monitor=eDP-1,1920x1080,0x0,1
monitor=HDMI-A-1,1920x1080,0x0,1,mirror,eDP-1
```

### Appearance
Modify the decoration section in `hyprland.conf` for:
- Border colors and thickness
- Rounded corners
- Blur effects
- Opacity settings

## Troubleshooting

### Screen sharing not working
Run the XDG portal reset script:
```bash
~/.config/hypr/scripts/resetxdgportal.sh
```

### Waybar not starting
Check the waybar starter script and ensure waybar is installed:
```bash
~/.config/hypr/scripts/waybar-starter.sh
```

### Wallpaper not loading
1. Check that the wallpaper paths in `hyprpaper.conf` are correct
2. Ensure the image files exist and are readable
3. Restart hyprpaper: `killall hyprpaper && hyprpaper &`

## Contributing

Feel free to submit issues and enhancement requests! When contributing:

1. Test your changes thoroughly
2. Update documentation if needed
3. Follow the existing code style
4. Make sure scripts have proper error handling

## License

This configuration is provided as-is for personal use. Feel free to modify and adapt to your needs.