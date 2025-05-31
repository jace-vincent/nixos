{config, pkgs, lib, ...}:

{

  virtualisation.virtualbox.guest.enable = true;

  # When using the VM we're going to override the boot to a more stable v
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

}
