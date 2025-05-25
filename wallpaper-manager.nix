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
      selected_wallpaper=$(nsxiv -t -o "$WALLPAPER_DIR")
      
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
