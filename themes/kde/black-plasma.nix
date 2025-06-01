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

    # Desktop and panels configuration
    desktop = {
      mouseActions = {
      rightClick = "contextMenu";
      };
    };
  };
}

