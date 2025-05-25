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
          
          # Set wallpaper using KDE's plasma-apply-wallpaperimage (requires plasma-workspace package)
          if command -v plasma-apply-wallpaperimage &> /dev/null; then
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
           "editor.lineHighlightBackground": $line
         }' "$VSCODE_SETTINGS" > "/tmp/vscode_settings_temp.json"
      
      # Replace the original settings file
      mv "/tmp/vscode_settings_temp.json" "$VSCODE_SETTINGS"
      
      echo "VS Code colors updated instantly!"
    '';
    executable = true;
  };

  # Script to update VS Code settings with pywal colors
  home.file.".local/bin/update-vscode-nix-colors" = {
    text = ''
      #!/usr/bin/env bash
      
      # Path to pywal colors
      COLORS_FILE="$HOME/.cache/wal/colors"
      VSCODE_NIX_FILE="/etc/nixos/vscode.nix"
      
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
          feh --bg-scale "$full_path"
          wal -i "$full_path"
          
          echo "Wallpaper set: $selected"
      fi
    '';
    executable = true;
  };
}
