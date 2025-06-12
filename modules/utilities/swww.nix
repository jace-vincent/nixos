{ config, pkgs, lib, userSettings, ... }:
{
  home.packages = with pkgs; [
    swww
  ];

  xdg.configFile."hypr/hyprland.conf".text = ''
    exec-once = swww-daemon
    exec-once = swww img ~/Documents/wallpapers/yourwallpaper.png
  '';
}
