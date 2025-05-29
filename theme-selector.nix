{ config, pkgs, lib, ... }:
{
  # Theme Selection Configuration
  # Change the active theme by modifying the import below
  
  # Available themes:
  # - ./themes/hyprland-dynamic.nix     (Current: Wayland, minimal animations, dynamic wallpaper theming)
  # - ./themes/kde-dark-wiggly.nix      (KDE Plasma, dark theme, fun animations, X11)
  
  imports = [
    # ACTIVE THEME - Change this line to switch themes
    ./themes/hyprland-dynamic.nix
    
    # Add additional theme imports here if you want to layer themes
  ];
  
  # Theme switching helper scripts
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "theme-switch" ''
      #!/usr/bin/env bash
      # Theme switching script
      
      THEME_DIR="/etc/nixos/themes"
      CONFIG_FILE="/etc/nixos/theme-selector.nix"
      
      echo "Available themes:"
      echo "1. hyprland-dynamic (Wayland, minimal, dynamic wallpaper)"
      echo "2. kde-dark-wiggly (KDE Plasma, dark, fun animations)"
      
      read -p "Select theme (1-2): " choice
      
      case $choice in
        1)
          sed -i 's|./themes/.*\.nix|./themes/hyprland-dynamic.nix|' "$CONFIG_FILE"
          echo "Switched to Hyprland Dynamic theme"
          ;;
        2)
          sed -i 's|./themes/.*\.nix|./themes/kde-dark-wiggly.nix|' "$CONFIG_FILE"
          echo "Switched to KDE Dark Wiggly theme"
          ;;
        *)
          echo "Invalid selection"
          exit 1
          ;;
      esac
      
      echo "Run 'sudo nixos-rebuild switch --flake .#nixos' to apply the theme"
    '')
  ];
}
