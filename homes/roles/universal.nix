{pkgs, lib, ...}: 
{
  home.stateVersion = "23.11";

  programs.kitty.enable = true;

  xdg.mimeApps.enable = true; # Enable support for default apps. 
  
  kalyx = { };
}
