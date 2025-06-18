{config, pkgs, machine, ...}:

{
  # Bootloader - this works for the lenovo yoga laptop
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Bootloader - this works for the lenovo yoga laptop
  boot.loader.systemd-boot.enable = if machine == "laptop" then true else false;
  boot.loader.efi.canTouchEfiVariables = if machine == "laptop" then true else false; 

  # Bootloader - grub for virtual machines
  boot.loader.grub.enable = if machine == "vm" then true else false;
  boot.loader.grub.device = if machine == "vm" then "/dev/sda" else null;
  boot.loader.grub.useOSProber = if machine == "vm" then true else false;
}

  
