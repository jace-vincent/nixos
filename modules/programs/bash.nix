# modules/programs/bash.nix
{ config, pkgs, ... }:
{
  # System-wide bash configuration
  programs.bash = {
    completion.enable = true;
    enableLsColors = true;
    
    # System-wide bash aliases
    shellAliases = {
      # Basic safety aliases
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      
      # Common shortcuts
      ll = "ls -l";
      la = "ls -la";
      
      # System info
      df = "df -h";
      du = "du -h";
    };
  };

  # Set bash as default system shell
  users.defaultUserShell = pkgs.bash;
  
  # Make zsh available for users who want it
  programs.zsh.enable = true;
}
