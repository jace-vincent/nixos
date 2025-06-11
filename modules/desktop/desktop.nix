{ config, pkgs, ... }:
{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # Disable KDE's compositor to avoid conflicts with picom
  services.desktopManager.plasma6.enableQt5Integration = false;
  
  # Enable picom compositor for transparency effects
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
    # VS Code transparency rules (much more noticeable)
    opacityRules = [
      "60:class_g = 'Code'"      # Very transparent for testing
      "70:class_g = 'Alacritty'"
      "80:class_g = 'firefox'"
      "70:class_g = 'kitty'"
    ];
    # Additional transparency settings
    settings = {
      # Backend for better performance and transparency support
      backend = "glx";
      # Blur background
      blur-background = true;
      blur-method = "dual_kawase";
      blur-strength = 5;
      # Corner radius for modern look
      corner-radius = 8;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
      # Force transparency to work properly
      detect-client-opacity = true;
      # Prevent flickering
      detect-transient = true;
      detect-client-leader = true;
    };
  };
  
  # Enable touchpad support (optional)
  # services.xserver.libinput.enable = true;
  # KDE PAM wallet config - DISABLED to use GNOME Keyring instead
  # security.pam.services.login.enableKwallet = true;
}
