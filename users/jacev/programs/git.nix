{config, pkgs, ...}:

  { 
    programs.git = {
      enable = true;
      config = {
       user = {
         Name = "Jace Vincent";
         Email = "txjacev@gmail.com";
        };
      };
    };
  }
