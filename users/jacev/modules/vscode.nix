{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode
  ];

  programs.vscode = {
  enable = true;
  profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      matangover.mypy
      ];
    };
  };
}
