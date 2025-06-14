{ config, pkgs, ... }:
{
  # User profile for jacev - system-level user account configuration
  users.users.jacev = {
    isNormalUser = true;
    description = "Jace Vincent";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # User-specific packages go here
      # Desktop environment packages are managed in modules/desktop/
      obsidian
    ];
  };

  # Auto-login configuration
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jacev";
}
