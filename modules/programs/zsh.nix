# modules/programs/zsh.nix
{ config, pkgs, lib, ... }:
{
  # User-level zsh configuration (Home Manager)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    
    # Oh-my-zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "git" 
        "sudo" 
        "docker" 
        "kubectl"
        "systemd"
        "colored-man-pages"
      ];
      theme = "robbyrussell";
    };
    
    # Zsh-specific settings
    initExtra = ''
      # Custom zsh configuration
      setopt AUTO_CD
      setopt GLOB_DOTS
      setopt NOMATCH
      setopt MENU_COMPLETE
      setopt AUTO_LIST
    '';
  };
}
