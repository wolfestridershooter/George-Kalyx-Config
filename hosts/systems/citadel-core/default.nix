#

{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    ports = [ 27069 ];
  };

  imports = [
    ./hardware.nix
  ];
  
  # Setup Kalyx functionality.
  kalyx = { };

  environment.systemPackages = with pkgs; [
    firefox
  ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
