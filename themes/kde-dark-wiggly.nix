{ config, pkgs, ... }:
{
  # KDE Dark Theme with Wiggly Windows
  # This theme provides a complete KDE Plasma experience with fun animations
  
  # Import the KDE desktop environment module
  imports = [
    ../modules/desktop/kde.nix
  ];
  
  # Theme-specific KDE configuration
  environment.systemPackages = with pkgs; [
    # Additional KDE customization packages
    kdePackages.plasma-desktop
    kdePackages.kwin-effects-forceblur
  ];
  
  # KDE-specific theming and effects
  environment.sessionVariables = {
    # KDE theme variables
    QT_QPA_PLATFORMTHEME = "kde";
    QT_STYLE_OVERRIDE = "breeze-dark";
    KDE_SESSION_VERSION = "5";
  };
  
  # Theme metadata
  system.nixos.tags = [ "kde" "dark" "wiggly" "x11" ];
}
