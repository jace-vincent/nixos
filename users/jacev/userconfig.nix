  {config, pkgs, ...}:
  {
  # Here is where we define all of the user specific configs and packages
    users.users.jacev = {
      isNormalUser = true;
      description = "Jace Vincent";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
      neofetch
      ];
    };
  }
