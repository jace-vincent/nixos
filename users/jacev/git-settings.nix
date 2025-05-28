{ config, pkgs, lib, ... }:

{
  # Personal Git preferences for jacev
  # This contains user-specific git configuration
  
  userInfo = {
    # Personal identity - update these with your actual details
    name = "Jace Vincent";
    email = "jacev@example.com";  # Update with your actual email
  };
  
  # Personal git configuration (non-alias settings)
  extraConfig = {
    # UI and behavior preferences
    init.defaultBranch = "main";
    pull.rebase = false;  # Use merge instead of rebase for pulls
    push.default = "simple";
    
    # Better diff and merge tools
    diff.tool = "vimdiff";
    merge.tool = "vimdiff";
    
    # Color preferences
    color.ui = true;
    color.branch = "auto";
    color.diff = "auto";
    color.status = "auto";
    
    # Personal workflow preferences
    core.editor = "code --wait";  # Use VS Code as git editor
    core.autocrlf = false;        # Don't auto-convert line endings
    
    # Security preferences
    commit.gpgsign = false;       # Set to true if you want to sign commits
  };
}
