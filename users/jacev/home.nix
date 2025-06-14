{ config, pkgs, userSettings, ... }: {
  programs.git = {
    enable = true;
    userName = userSettings.name;    # Uses your flake variable
    userEmail = userSettings.email;  # Uses your flake variable
    extraConfig = {
      credential.helper = "${pkgs.git}/bin/git-credential-libsecret";
    };
  };

  home.packages = with pkgs; [
    libsecret
    gnome.seahorse
  ];

}
