{pkgs, lib, ...}: 
{
  home.stateVersion = "23.11";

  programs.kitty.enable = true;

  kalyx = {
    vscode.enable = true;
    neofetch.enable = true;
  };
}
