# Drop your generated hardware config in here, along with any kalyx specific configuration options.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  kalyx = {
    # GPU Options
    intelgpu.enable = lib.mkDefault false;
    amdgpu.enable = lib.mkDefault false;
    nvidia.enable = lib.mkDefault false;

    # CPU Options
    intel.enable = lib.mkDefault false;
    amd.enable = lib.mkDefault false;

    # Sound Options
    sound = {
      enable = true;
      soundServer = "pipewire"; # This can be 'pipewire' (default) or 'pulse'.
    };                          # NOTE: Pipewire can be enabled seperetly without audio using 'kalyx.pipewire.enable = true';

    # Networking Options
    broadcom.enable = lib.mkDefault true;
  };

  # V Drop options of hardware-configuration.nix here V:
  
}
