{ config, pkgs, lib, ... }:
{
  # Theme Selection Configuration
  # Change the active theme by modifying the import below
  
  # Available themes:
  # - ./themes/hyprland-dynamic.nix     (Current: Wayland, minimal animations, dynamic wallpaper theming)
  # - ./themes/kde-dark-wiggly.nix      (KDE Plasma, dark theme, fun animations, X11)
  
  imports = [
    # ACTIVE THEME - Change this line to switch themes
    ../../themes/hyprland-static.nix
    
    # Add additional theme imports here if you want to layer themes
  ];
}
