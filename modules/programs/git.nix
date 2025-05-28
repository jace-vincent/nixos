{ config, pkgs, lib, ... }:

let
  # Import user-specific git settings
  userGitSettings = import ../../users/jacev/git-settings.nix { inherit config pkgs lib; };
in
{
  # Generic Git module - theme-agnostic and user-agnostic setup
  # Personal preferences come from user settings
  # Git aliases are handled by shell aliases for consistency (e.g., "gst" = "git status")
  
  programs.git = {
    enable = true;
    
    # Import user identity
    userName = userGitSettings.userInfo.name;
    userEmail = userGitSettings.userInfo.email;
    
    # No git aliases here - they're handled as shell aliases in aliases.nix
    # This keeps all aliases centralized in one place
    
    # Import user configuration
    extraConfig = userGitSettings.extraConfig;
    
    # Git-specific packages that might be useful
    # These are generic and work for any user
  };
  
  # Install useful git-related tools
  home.packages = with pkgs; [
    git-lfs          # Large file support
    gitui            # Terminal UI for git
    gh               # GitHub CLI
    # tig            # Text-mode interface for git (optional)
  ];
}
