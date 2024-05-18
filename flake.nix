{
  description = "Template config using kalyx.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nur.url = "github:nix-community/NUR"; 

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kalyx = {
      url = "file:./kalyx?submodules=1";
      type = "git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    kyler = {
      url = "file:./kyler?submodules=1";
      type = "git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ flake-parts, kalyx, kyler, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (toplevel@ {config, flake-parts-lib, ...}: #
      let
        inherit (flake-parts-lib) importApply;

        flakeModules = {
          machines = importApply ./flake-parts/machines toplevel;
        };
      in {
        imports = with flakeModules; [
          machines
        ];

        systems = [ "x86_64-linux" ];

        machines = {
          system1 = {
            nixosModules = [ kalyx.nixosModules.default ];
            homeManagerModules = [ kalyx.homeManagerModules.default kyler.homeManagerModules.default ];
            configuration = ./hosts/systems/system1;
            roles = [ ./hosts/roles/universal.nix ./hosts/roles/pc.nix ];
            hardware = ./hosts/systems/system1/hardware.nix;
            stateVersion = "23.11";
            hostPlatform = "x86_64-linux";
            users = {
              user1 = {
                groups = [ "networkmanager" "wheel" "dialout" ] ++ kalyx.universalGroups ++ kalyx.adminGroups;
                noSudoPassword = false; # Set this to true if you dont want sudo to prompt you for a password.
                configuration = ./homes/users/user1/system1.nix;
                roles = [ ./homes/roles/universal.nix ./homes/roles/pc.nix ];
              };
            };
          };
        };
      });
}
