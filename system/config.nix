  {config, pkgs, ...}:
  
  {
    # imports in our system/config file are mostly just programs we want to set some default configs on
    # that go a bit beyond simply installing them as a package
    imports = [
    ../modules/programs/firefox.nix
    ../modules/programs/git.nix
    ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
    wget
    neovim
    alacritty
    ];
  }
