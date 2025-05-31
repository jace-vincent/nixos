  {config, pkgs, ...}:
  
  {
    imports = [
    ../modules/programs/firefox.nix
    ];


    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    alacritty
    ];
  }
