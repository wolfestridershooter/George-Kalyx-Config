{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ];

  kalyx = {
    # GPU Options
    intelgpu.enable = lib.mkDefault true;
    amdgpu.enable = lib.mkDefault false;
    nvidia.enable = lib.mkDefault false;

    # CPU Options
    intel.enable = true;
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
        primary = true;
        resolution = "3840x2160";
        framerate = 60;
        position = "0x0";
        adapter = "HDMI-A-2";
        workspaces = [1 2 3 4 5 6 7 8 9 0];
        defaultWorkspace = 1;
        bitdepth = 10;
        scale = 2;
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
  kalyx = {
    scream = {
      enable = true;
      unicast = true;
      maxLatency = 50;
      latency = 25;
    };

    camera = {
      enable = true;
      virtualCam = {
        enable = true;
        camNumbers = [8 9];
      };
    };
  };

  networking = { 
    useDHCP = false;

    interfaces = {
      eno1.useDHCP = true;
      br0.useDHCP = true;
    };

    bridges = {
      "br0" = {
        interfaces = [ "eno1" ];
      };
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    };
  };

  kalyx.virtualisation.cpuarch = "intel";
  kalyx.virtualisation = {
	  vfioids = [
      "10de:2684"
      "10de:22ba"
      "1912:0015"
    ];
    virtcpus = "30-31";
    hostcpus = "0-31";
    enable = true;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.interfaces.enp0s31f6.useDHCP = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fc9c043f-06d9-49fa-bebd-706137640638";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B205-A19A";
      fsType = "vfat";
    };

  fileSystems."/home/george/All Files" =
    { device = "/dev/disk/by-uuid/050d8efc-17cc-4725-a039-b9ad9ec5240e";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
