{ config, pkgs, ... }:
{
  users.users.jacev = {
    isNormalUser = true;
    description = "Jace Vincent";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jacev";
}
