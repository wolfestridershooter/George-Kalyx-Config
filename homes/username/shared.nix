{pkgs, lib, ...}:
let 
  modKey = "ALT";
in
{
  home.stateVersion = "23.11";

  programs.kitty.enable = true;

  kalyx = {
    tofi = {
      enable = true;
      bind = "${modKey},r";
    };
    vscode.enable = true;
    neofetch.enable = true;
  };
}
