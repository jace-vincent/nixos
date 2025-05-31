  {config, pkgs, ...}:
  
  {
    # imports in our system/config file are mostly just programs we want to set some default configs on
    # that go a bit beyond simply installing them as a package
    imports = [
    ../themes/basic.nix # Very spartan theme designed for reliability
    ../modules/hardware/audio.nix # very important! 
    ../modules/services/printing.nix # not required but very useful
    ../modules/programs/firefox.nix # our default system browser
    ../modules/programs/git.nix # everybody needs git
    ];

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "America/Denver";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
    wget
    neovim
    alacritty
    ];
  }
