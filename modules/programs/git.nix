{config, pkgs, ...}:

{ 
  programs.git = {
    enable = true;
    config = {
      credential.helper = "store";
      init.defaultBranch = "main";
      user = {
        Name = "Jace Vincent";
        Email = "txjacev@gmail.com";
      };
    };
  };
}  
