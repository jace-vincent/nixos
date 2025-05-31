{config, pkgs, ...}:

{
  # A regal KDE Plasma 6 with all the bells and whistles
  imports = [ 
  ../modules/desktops/kde.nix
  ../modules/services/x11.nix
  ];

}
