# themes/kde/black-plasma.nix
{ config, pkgs, lib, ... }:

{

  # Define packages as a simple attribute
  home.packages = with pkgs; [  
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
  ];

  # Declarative KDE configuration with plasma-manager
  programs.plasma = {
    enable = true;
  
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
    };
  
    # Window decoration settings
    kwin = {
      titlebarButtons = {
        left = [ "on-all-desktops" ];
        right = [ "minimize"  "maximize"  "close" ];
      };
    };
  };

  # Configure KDE settings via dconf/files
  #  home.file.".config/kdeglobals".text = '' 
  #    [ColorScheme]
  #    ColorScheme=BreezeDark
  #
  #    [General]
  #    ColorScheme=BreezeDark
  #    Name=Breeze Dark
  #
  #    [Icons]
  #    Theme=breeze-dark
  #
  #    [KDE]
  #    LookAndFeelPackage=org.kde.breezedark.desktop
  #    widgetStyle=breeze
  #    '';
  #
  #    home.file.".config/kwinrc".text = ''
  #      [org.kde.kdecoration2]
  #      library=org.kde.breeze
  #      theme=Breeze
  #
  #      [Compositing]
  #      OpenGLIsUnsafe=false
  #
  #      [Effect-overview]
  #      BorderActivate-9
  #    '';
  #
  #      # GTK theme for non-KDE apps
  #    home.file.".config/gtk-3.0/settings.ini".text = ''
  #      [Settings]
  #      gtk-theme-name=Breeze-Dark
  #      gtk-icon-theme-name=breeze-dark
  #      gtk-application-prefer-dark-theme=1
  #    '';
  #
}
