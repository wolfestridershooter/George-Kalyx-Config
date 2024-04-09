# Drop your generated hardware config in here, along with any kalyx specific configuration options.

{ config, lib, pkgs, modulesPath, ... }: {
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
    broadcom.enable = lib.mkDefault false;

    # Bluetooth
    bluetooth.enable = lib.mkDefault true;

    # Monitors (see https://github.com/Juiced-Devs/Kalyx/blob/main/modules/nixos/hardware/monitors.nix)
    monitors = [
      {
        resolution = "1920x1080";
        framerate = 60;
        position = "0x0";
        adapter = "HDMI-X-Y";
        workspaces = [1 2 3];
        defaultWorkspace = 1;
        bitdepth = 10;
      }
    ];

    defaultMonitor = { # Setup a monitor that will be applied to all unspecified monitors
      resolution = "preffered";
      position = "automatic";
    };
  };

  hardware.enableRedistributableFirmware = true; # Fixes some missing kernel module problems.
                                                               # Delete this if your existing config you are about to paste already has this option set as it may cause an error.

  # V Drop options of hardware-configuration.nix here V:

}
