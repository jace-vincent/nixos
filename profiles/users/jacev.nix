{ config, pkgs, ... }:
{
  # User profile for jacev - system-level user account configuration
  # This handles the actual user account, groups, and system-level settings
  # User-specific application settings are in users/jacev/
  
  users.users.jacev = {
    isNormalUser = true;
    description = "Jace Vincent";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  # Auto-login configuration for this user
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jacev";
}
