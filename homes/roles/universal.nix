{pkgs, lib, ...}: 
{
  programs.kitty.enable = true;

  xdg.mimeApps.enable = true; # Enable support for default apps. 
  
  kalyx = { };
}
