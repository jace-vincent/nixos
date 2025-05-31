  {config, pkgs, ...}:

  {
  imports = [
  ./programs/git.nix
  ];

  # Here is where we define all of the user specific configs and packages
    users.users.jacev = {
      isNormalUser = true;
      description = "Jace Vincent";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
      neofetch
      ];
    };
  
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jacev";
  }
