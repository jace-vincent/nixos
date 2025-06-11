{ config, pkgs, ... }:
{
  # Wallpaper management script using nsxiv and pywal
  home.file.".local/bin/wallpaper-select" = {
    text = ''
      #!/usr/bin/env bash
      
      # Wallpaper directory - adjust this path as needed
      WALLPAPER_DIR="$HOME/Documents/wallpapers"
      
      # Check if wallpaper directory exists
      if [ ! -d "$WALLPAPER_DIR" ]; then
          echo "Wallpaper directory not found: $WALLPAPER_DIR"
          echo "Please create the directory and add some wallpapers!"
          exit 1
      fi
      
      # Check if directory has images
      if [ -z "$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print -quit)" ]; then
          echo "No images found in $WALLPAPER_DIR"
          echo "Please add some wallpapers (jpg, png, webp formats supported)"
          exit 1
      fi
      
      echo "Opening nsxiv image selector..."
      echo "Instructions:"
      echo "1. Use arrow keys to navigate thumbnails"
      echo "2. Press 'm' to MARK the wallpaper you want"
      echo "3. Press 'q' to quit and apply the marked wallpaper"
      echo ""
      
      # Use nsxiv to select wallpaper
      # The -o flag outputs marked filenames when you quit
      # The -t flag starts in thumbnail mode for easier browsing
      # Additional flags for cleaner appearance:      
      # -b removes window decorations/borders
      # -N sets custom window class name (removes nsxiv branding)
      # -f fits images to window (removes padding)
      selected_wallpaper=$(nsxiv -t -o -b -N "wallpaper-selector" -f "$WALLPAPER_DIR")
      
      # Check if user selected a wallpaper (didn't just close nsxiv)
      if [ -n "$selected_wallpaper" ]; then
          echo "Setting wallpaper: $(basename "$selected_wallpaper")"
          
          # Set wallpaper using swww for Hyprland/Wayland or feh for X11
          if command -v swww &> /dev/null; then
              # Check if swww daemon is running, start if needed
              if ! pgrep -x "swww-daemon" > /dev/null; then
                  swww init
                  sleep 1  # Give daemon time to start
              fi
              swww img "$selected_wallpaper" --transition-type wipe --transition-duration 1
          elif command -v plasma-apply-wallpaperimage &> /dev/null; then
              plasma-apply-wallpaperimage "$selected_wallpaper"
          else
              feh --bg-scale "$selected_wallpaper"
          fi
          
          # Generate color scheme with pywal
          if command -v wal &> /dev/null; then
              wal -i "$selected_wallpaper"
              
              # Update VS Code colors directly (fast, no rebuild needed)
              ~/.local/bin/update-vscode-colors-direct
              
              echo "Wallpaper and color scheme updated!"
          else
              echo "Wallpaper set! (pywal not available for color generation)"
          fi
      else
          echo "No wallpaper selected"
      fi
    '';
    executable = true;
  };

  # Fast VS Code color updater - modifies settings.json directly
  home.file.".local/bin/update-vscode-colors-direct" = {
    text = ''
      #!/usr/bin/env bash
      
      # Path to pywal colors and VS Code settings
      COLORS_FILE="$HOME/.cache/wal/colors"
      VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
      
      # Check if pywal colors exist
      if [ ! -f "$COLORS_FILE" ]; then
          echo "Pywal colors not found. Run 'wal -i /path/to/image' first."
          exit 1
      fi
      
      # Check if VS Code settings exist
      if [ ! -f "$VSCODE_SETTINGS" ]; then
          echo "VS Code settings.json not found. Please open VS Code first."
          exit 1
      fi
      
      # Read pywal colors
      mapfile -t colors < "$COLORS_FILE"
      
      # Extract colors
      bg_color="''${colors[0]}"
      fg_color="''${colors[7]}"
      accent_color="''${colors[1]}"
      selection_color="''${colors[2]}"
      line_highlight="''${colors[8]}50"
      
      # Create temporary settings file with updated colors
      # This merges colors with existing settings instead of overwriting
      jq --arg bg "$bg_color" \
         --arg fg "$fg_color" \
         --arg accent "$accent_color" \
         --arg selection "$selection_color" \
         --arg line "$line_highlight" \
         '.["workbench.colorCustomizations"] = {
           "editor.background": $bg,
           "editor.foreground": $fg,
           "activityBar.background": $bg,
           "activityBar.foreground": $fg,
           "sideBar.background": $bg,
           "sideBar.foreground": $fg,
           "panel.background": $bg,
           "panel.border": $accent,
           "terminal.background": $bg,
           "terminal.foreground": $fg,
           "statusBar.background": $accent,
           "statusBar.foreground": $bg,
           "editor.selectionBackground": $selection,
           "editor.lineHighlightBackground": $line,
           "titleBar.activeBackground": $bg,
           "titleBar.activeForeground": $fg,
           "titleBar.inactiveBackground": $bg,
           "titleBar.inactiveForeground": $fg
         }' "$VSCODE_SETTINGS" > "/tmp/vscode_settings_temp.json"
      
      # Only replace if jq succeeded
      if [ $? -eq 0 ]; then
          mv "/tmp/vscode_settings_temp.json" "$VSCODE_SETTINGS"
          echo "VS Code colors updated with pywal theme!"
      else
          echo "Failed to update VS Code colors"
          rm -f "/tmp/vscode_settings_temp.json"
      fi
    '';
    executable = true;
  };

  # Script to update VS Code settings with pywal colors
  home.file.".local/bin/update-vscode-nix-colors" = {
    text = ''
      #!/usr/bin/env bash
      
      # Path to pywal colors
      COLORS_FILE="$HOME/.cache/wal/colors"
      VSCODE_NIX_FILE="/etc/nixos/modules/programs/vscode.nix"
      
      # Check if pywal colors exist
      if [ ! -f "$COLORS_FILE" ]; then
          echo "Pywal colors not found. Run 'wal -i /path/to/image' first."
          exit 1
      fi
      
      # Read pywal colors
      mapfile -t colors < "$COLORS_FILE"
      
      # Extract specific colors (pywal generates 16 colors)
      bg_color="''${colors[0]}"      # Background
      fg_color="''${colors[7]}"      # Foreground  
      accent_color="''${colors[1]}"  # Accent/highlight
      selection_color="''${colors[2]}" # Selection
      
      echo "Updating VS Code configuration with pywal colors..."
      
      # Create a temporary file with updated colors
      cat > "/tmp/vscode-colors.nix" << EOF
        # Pywal integration - Auto-generated colors from current wallpaper
        "workbench.colorCustomizations" = {
          "editor.background" = "$bg_color";
          "editor.foreground" = "$fg_color";
          "activityBar.background" = "$bg_color";
          "activityBar.foreground" = "$fg_color";
          "sideBar.background" = "$bg_color";
          "sideBar.foreground" = "$fg_color";
          "panel.background" = "$bg_color";
          "panel.border" = "$accent_color";
          "terminal.background" = "$bg_color";
          "terminal.foreground" = "$fg_color";
          "statusBar.background" = "$accent_color";
          "statusBar.foreground" = "$bg_color";
          "editor.selectionBackground" = "$selection_color";
          "editor.lineHighlightBackground" = "''${colors[8]}50";
        };
EOF
      
      # Use sed to replace the workbench.colorCustomizations section in vscode.nix
      # This is a simplified approach - in practice you might want more robust parsing
      sudo sed -i '/# Pywal integration/,/};/c\
        # Pywal integration - Auto-generated colors from current wallpaper\
        "workbench.colorCustomizations" = {\
          "editor.background" = "'$bg_color'";\
          "editor.foreground" = "'$fg_color'";\
          "activityBar.background" = "'$bg_color'";\
          "activityBar.foreground" = "'$fg_color'";\
          "sideBar.background" = "'$bg_color'";\
          "sideBar.foreground" = "'$fg_color'";\
          "panel.background" = "'$bg_color'";\
          "panel.border" = "'$accent_color'";\
          "terminal.background" = "'$bg_color'";\
          "terminal.foreground" = "'$fg_color'";\
          "statusBar.background" = "'$accent_color'";\
          "statusBar.foreground" = "'$bg_color'";\
          "editor.selectionBackground" = "'$selection_color'";\
          "editor.lineHighlightBackground" = "''${colors[8]}50";\
        };' "$VSCODE_NIX_FILE"
      
      # Rebuild home-manager to apply changes
      echo "Rebuilding home-manager with new colors..."
      cd /etc/nixos && sudo nixos-rebuild switch --flake .#nixos
      
      echo "VS Code colors updated and applied!"
    '';
    executable = true;
  };
  
  # Alternative script using dmenu for directory selection
  home.file.".local/bin/wallpaper-dmenu" = {
    text = ''
      #!/usr/bin/env bash
      
      WALLPAPER_DIR="$HOME/Documents/wallpapers"
      
      # Check if wallpaper directory exists
      if [ ! -d "$WALLPAPER_DIR" ]; then
          echo "Wallpaper directory not found: $WALLPAPER_DIR"
          exit 1
      fi
      
      # Find all image files and present them in dmenu
      selected=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -printf "%f\n" | dmenu -p "Select wallpaper:")
      
      if [ -n "$selected" ]; then
          full_path="$WALLPAPER_DIR/$selected"
          
          # Set wallpaper and generate colors
          if command -v swww &> /dev/null; then
              swww img "$full_path" --transition-type wipe --transition-duration 2
          else
              feh --bg-scale "$full_path"
          fi
          wal -i "$full_path"
          
          echo "Wallpaper set: $selected"
      fi
    '';
    executable = true;
  };
  
  # Startup wallpaper script for smooth Hyprland boot
  home.file.".local/bin/startup-wallpaper" = {
    text = ''
      #!/usr/bin/env bash
      
      # This script runs at Hyprland startup to immediately set wallpaper
      # preventing the default background from showing
      
      # Wallpaper paths
      WALLPAPER_DIR="$HOME/Documents/wallpapers"
      DEFAULT_WALLPAPER="$WALLPAPER_DIR/default.jpg"
      CACHED_WALLPAPER="$HOME/.cache/wal/wal"
      
      # Determine which wallpaper to use
      STARTUP_WALLPAPER=""
      if [ -f "$CACHED_WALLPAPER" ]; then
          STARTUP_WALLPAPER="$CACHED_WALLPAPER"
      elif [ -f "$DEFAULT_WALLPAPER" ]; then
          STARTUP_WALLPAPER="$DEFAULT_WALLPAPER"
      elif [ -d "$WALLPAPER_DIR" ]; then
          STARTUP_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print -quit)
      fi
      
      # Initialize swww daemon in background and immediately set wallpaper
      if [ -n "$STARTUP_WALLPAPER" ] && [ -f "$STARTUP_WALLPAPER" ]; then
          # Start swww daemon
          swww init &
          SWWW_PID=$!
          
          # Very brief wait for daemon to initialize
          sleep 0.1
          
          # Aggressively try to set wallpaper immediately (multiple attempts)
          for i in {1..5}; do
              if swww img "$STARTUP_WALLPAPER" --transition-type none --transition-duration 0 2>/dev/null; then
                  echo "Wallpaper applied successfully on attempt $i"
                  break
              fi
              sleep 0.1
          done
          
          # Apply colors if pywal cache exists (but don't regenerate at startup for speed)
          if [ -f "$HOME/.cache/wal/colors" ]; then
              ~/.local/bin/update-vscode-colors-direct 2>/dev/null &
          fi
      else
          # Still initialize swww even if no wallpaper found
          swww init &
          echo "No wallpaper found for startup"
      fi
    '';
    executable = true;
  };
  
  # Script to set up wallpaper directory with a default wallpaper
  home.file.".local/bin/setup-wallpapers" = {
    text = ''
      #!/usr/bin/env bash
      
      WALLPAPER_DIR="$HOME/Documents/wallpapers"
      
      echo "Setting up wallpaper directory..."
      
      # Create wallpaper directory if it doesn't exist
      mkdir -p "$WALLPAPER_DIR"
      
      # Create a simple default wallpaper if none exists
      if [ ! -f "$WALLPAPER_DIR/default.jpg" ] && command -v convert &> /dev/null; then
          echo "Creating default wallpaper..."
          # Create a simple gradient wallpaper using ImageMagick
          convert -size 2560x1440 gradient:#1e1e2e-#313244 "$WALLPAPER_DIR/default.jpg"
          echo "Created default gradient wallpaper"
      fi
      
      # Check for existing wallpapers
      wallpaper_count=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | wc -l)
      
      if [ "$wallpaper_count" -eq 0 ]; then
          echo ""
          echo "No wallpapers found in $WALLPAPER_DIR"
          echo "Please add some wallpaper images (jpg, png, webp) to this directory."
          echo ""
          echo "You can:"
          echo "1. Copy your favorite wallpapers to $WALLPAPER_DIR"
          echo "2. Download wallpapers from the internet"
          echo "3. Use the current setup with a solid color background"
      else
          echo "Found $wallpaper_count wallpaper(s) in $WALLPAPER_DIR"
          echo "Run 'wallpaper-select' to choose a wallpaper!"
      fi
    '';
    executable = true;
  };
  
  # Pre-Hyprland wallpaper preparation script
  home.file.".local/bin/pre-hyprland-setup" = {
    text = ''
      #!/usr/bin/env bash
      
      # This script can be run before Hyprland starts to prepare wallpaper
      # It ensures the wallpaper directory exists and creates a fallback
      
      WALLPAPER_DIR="$HOME/Documents/wallpapers"
      DEFAULT_WALLPAPER="$WALLPAPER_DIR/default.jpg"
      
      # Create wallpaper directory if it doesn't exist
      mkdir -p "$WALLPAPER_DIR"
      
      # Create a simple dark wallpaper if no default exists
      if [ ! -f "$DEFAULT_WALLPAPER" ]; then
          if command -v convert &> /dev/null; then
              # Create a dark gradient wallpaper that matches Hyprland's background
              convert -size 2560x1440 gradient:'#1e1e2e'-'#313244' "$DEFAULT_WALLPAPER" 2>/dev/null
          elif command -v magick &> /dev/null; then
              # Alternative ImageMagick command
              magick -size 2560x1440 gradient:'#1e1e2e'-'#313244' "$DEFAULT_WALLPAPER" 2>/dev/null
          else
              echo "Warning: ImageMagick not available, cannot create default wallpaper"
          fi
      fi
      
      echo "Wallpaper directory prepared: $WALLPAPER_DIR"
    '';
    executable = true;
  };
  
  # VS Code initialization script to set up essential settings
  home.file.".local/bin/vscode-init" = {
    text = ''
      #!/usr/bin/env bash
      
      # VS Code settings initialization script with GNOME Keyring integration
      # Note: Terminal settings and core preferences are now managed declaratively through Nix
      # This script only handles dynamic settings like colors and workspace-specific configs
      
      VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
      VSCODE_DIR="$HOME/.config/Code/User"
      
      # Create VS Code config directory if it doesn't exist
      mkdir -p "$VSCODE_DIR"
      
      echo "VS Code terminal configuration is now managed declaratively through Nix."
      echo "Terminal will default to zsh automatically after nixos-rebuild switch."
      echo ""
      echo "Current status:"
      if [ -f "$VSCODE_SETTINGS" ]; then
          if grep -q '"terminal.integrated.defaultProfile.linux"' "$VSCODE_SETTINGS"; then
              current_terminal=$(jq -r '."terminal.integrated.defaultProfile.linux" // "not set"' "$VSCODE_SETTINGS" 2>/dev/null || echo "unable to parse")
              echo "- Current terminal setting: $current_terminal"
          else
              echo "- Terminal setting: Will be set by Home Manager"
          fi
      else
          echo "- VS Code settings will be created by Home Manager"
      fi
      
      echo ""
      echo "To apply the new terminal configuration:"
      echo "1. Run: sudo nixos-rebuild switch --flake .#nixos"
      echo "2. Restart VS Code"
      echo "3. New terminals will open with zsh by default"
    '';
    executable = true;
  };
  
  # Script to update VS Code terminal to use zsh as default
  home.file.".local/bin/update-vscode-terminal-zsh" = {
    text = ''
      #!/usr/bin/env bash
      
      # Note: VS Code terminal configuration is now managed declaratively through Nix
      # This script is kept for backward compatibility but will inform users of the new approach
      
      echo "🔄 VS Code Terminal Configuration"
      echo ""
      echo "Terminal configuration is now managed declaratively through your Nix configuration."
      echo "The terminal default profile and environment are set in /etc/nixos/modules/programs/vscode.nix"
      echo ""
      echo "Current declarative configuration:"
      echo "- Default terminal: zsh"
      echo "- Available profiles: bash, zsh"
      echo "- Environment includes GNOME Keyring integration"
      echo ""
      echo "To apply configuration changes:"
      echo "1. Edit /etc/nixos/modules/programs/vscode.nix if needed"
      echo "2. Run: sudo nixos-rebuild switch --flake .#nixos"
      echo "3. Restart VS Code"
      echo ""
      echo "✅ No manual intervention required - zsh will be the default terminal"
      echo "   after the next system rebuild and VS Code restart."
    '';
    executable = true;
  };

  # Script to force VS Code terminal profile refresh and verification
  home.file.".local/bin/vscode-terminal-debug" = {
    text = ''
      #!/usr/bin/env bash
      
      # VS Code Terminal Profile Debug and Force Refresh
      echo "🔍 VS Code Terminal Profile Debug"
      echo ""
      
      # Check if VS Code is running
      if pgrep -f "code" > /dev/null; then
          echo "⚠️  VS Code is currently running"
          echo "   Please close ALL VS Code windows and instances for settings to take effect"
          echo ""
      fi
      
      # Check zsh availability
      echo "📍 Checking zsh availability:"
      if [ -x "/run/current-system/sw/bin/zsh" ]; then
          echo "✅ zsh found at: /run/current-system/sw/bin/zsh"
          echo "   Version: $(/run/current-system/sw/bin/zsh --version)"
      else
          echo "❌ zsh NOT found at expected path"
          echo "   Run: sudo nixos-rebuild switch --flake .#nixos"
          exit 1
      fi
      echo ""
      
      # Check VS Code settings
      VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
      echo "📋 Checking VS Code settings:"
      if [ -f "$VSCODE_SETTINGS" ]; then
          echo "✅ Settings file exists: $VSCODE_SETTINGS"
          
          # Check if it's a symlink (Home Manager managed)
          if [ -L "$VSCODE_SETTINGS" ]; then
              echo "✅ Settings managed by Home Manager (symlink)"
              echo "   Target: $(readlink "$VSCODE_SETTINGS")"
          else
              echo "⚠️  Settings file is NOT a symlink"
              echo "   This means you have a local settings.json that might override Home Manager"
          fi
          
          # Check terminal default profile
          if command -v jq &> /dev/null; then
              default_profile=$(jq -r '."terminal.integrated.defaultProfile.linux" // "not set"' "$VSCODE_SETTINGS" 2>/dev/null)
              echo "   Terminal default profile: $default_profile"
              
              # Check if zsh profile exists
              zsh_path=$(jq -r '."terminal.integrated.profiles.linux".zsh.path // "not set"' "$VSCODE_SETTINGS" 2>/dev/null)
              echo "   Zsh profile path: $zsh_path"
          else
              echo "   (jq not available for detailed settings check)"
          fi
      else
          echo "❌ VS Code settings.json not found"
          echo "   Settings should be created by Home Manager"
      fi
      echo ""
      
      # Check for workspace overrides
      if [ -d ".vscode" ]; then
          echo "📂 Workspace settings detected:"
          if [ -f ".vscode/settings.json" ]; then
              echo "⚠️  Local workspace settings found: .vscode/settings.json"
              if command -v jq &> /dev/null; then
                  workspace_terminal=$(jq -r '."terminal.integrated.defaultProfile.linux" // "not set"' ".vscode/settings.json" 2>/dev/null)
                  if [ "$workspace_terminal" != "not set" ]; then
                      echo "   Workspace overrides terminal to: $workspace_terminal"
                      echo "   This will override your user settings!"
                  fi
              fi
          else
              echo "✅ No workspace terminal overrides"
          fi
      else
          echo "✅ No workspace settings directory"
      fi
      echo ""
      
      # Instructions
      echo "🔧 To fix VS Code terminal profile:"
      echo "1. Close ALL VS Code windows/instances completely"
      echo "2. Kill any remaining VS Code processes:"
      echo "   pkill -f code"
      echo "3. Clear VS Code workspace state (if needed):"
      echo "   rm -rf ~/.config/Code/CachedExtensions"
      echo "   rm -rf ~/.config/Code/logs"
      echo "4. Restart VS Code and try Ctrl+Shift+\` again"
      echo ""
      echo "5. If it still doesn't work, try manually selecting the profile:"
      echo "   - Open Command Palette (Ctrl+Shift+P)"
      echo "   - Type: 'Terminal: Select Default Profile'"
      echo "   - Choose 'zsh'"
      echo ""
      echo "6. Alternative: Use the terminal dropdown in VS Code"
      echo "   - Click the dropdown arrow next to the + in terminal panel"
      echo "   - Select 'zsh' profile"
    '';
    executable = true;
  };

  # Script to completely reset VS Code terminal configuration
  home.file.".local/bin/vscode-reset-terminal" = {
    text = ''
      #!/usr/bin/env bash
      
      # Force reset VS Code terminal configuration
      echo "🔄 Resetting VS Code Terminal Configuration"
      echo ""
      
      # Stop VS Code if running
      if pgrep -f "code" > /dev/null; then
          echo "Stopping VS Code processes..."
          pkill -f code
          sleep 2
      fi
      
      # Remove VS Code cache and workspace state
      echo "Clearing VS Code cache..."
      rm -rf ~/.config/Code/CachedExtensions
      rm -rf ~/.config/Code/logs
      rm -rf ~/.config/Code/User/workspaceStorage
      
      # Remove any backup settings that might interfere
      if [ -f ~/.config/Code/User/settings.json.backup ]; then
          echo "Removing settings backup..."
          rm ~/.config/Code/User/settings.json.backup
      fi
      
      echo ""
      echo "✅ VS Code terminal configuration reset complete"
      echo ""
      echo "Next steps:"
      echo "1. Run: sudo nixos-rebuild switch --flake .#nixos"
      echo "2. Start VS Code fresh"
      echo "3. Open a new terminal with Ctrl+Shift+\`"
      echo "4. It should now default to zsh"
    '';
    executable = true;
  };
}
