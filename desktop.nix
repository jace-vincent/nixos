{ config, pkgs, ... }:
{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # Enable touchpad support (optional)
  # services.xserver.libinput.enable = true;
  # KDE PAM wallet config
  security.pam.services.login.enableKwallet = true;
}
