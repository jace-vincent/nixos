{config, pkgs, ...}:

{
  # A very spartan X11 and GNOME setup for servers or hardware tests
  imports = [
  ../../modules/services/x11.nix
  ];
  
}
