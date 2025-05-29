{ config, pkgs, ... }:

{
  # User account configuration for jacev
  users.users.jacev = {
    isNormalUser = true;
    description = "Jace Vincent";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  # Display manager auto-login configuration
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jacev";
}
