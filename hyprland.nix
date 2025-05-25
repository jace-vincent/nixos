{ config, pkgs, ... }:
{
  # Enable Hyprland window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable necessary services for Hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Disable conflicting services
  services.xserver.enable = false;
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;
  services.picom.enable = false;  # Hyprland has built-in compositor

  # Enable additional services for Hyprland
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # XDG portal for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Environment variables for Hyprland and 4K scaling
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Chromium/VS Code
    
    # 4K scaling environment variables
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "1.0";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.5";
    QT_FONT_DPI = "144";  # 96 * 1.5 for 4K scaling
    
    # Cursor scaling
    XCURSOR_SIZE = "32";
    
    # Additional Wayland scaling
    MOZ_ENABLE_WAYLAND = "1";  # Firefox Wayland support
  };

  # Additional packages needed for Hyprland
  environment.systemPackages = with pkgs; [
    waybar          # Status bar
    wofi           # Application launcher (dmenu replacement)
    swww           # Wallpaper daemon for Wayland
    grim           # Screenshot utility
    slurp          # Screen area selection
    wl-clipboard   # Clipboard manager
    mako           # Notification daemon
    brightnessctl  # Brightness control
    playerctl      # Media player control
  ];
}
