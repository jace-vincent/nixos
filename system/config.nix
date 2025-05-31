  {config, pkgs, ...}:
  
  {
    # imports in our system/config file are mostly just programs we want to set some default configs on
    # that go a bit beyond simply installing them as a package
    imports = [
    ../modules/hardware/audio.nix # very important! 
    ../modules/services/printing.nix # not required but very useful
    ../modules/programs/firefox.nix # our default system browser
    ../modules/programs/git.nix # everybody needs git
    ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
    wget
    neovim
    alacritty
    ];
  }
