{
  description = "Template config using kalyx.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nur.url = "github:nix-community/NUR"; 

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
          citadel-core = {
            nixosModules = [ kalyx.nixosModules.default ];
            homeManagerModules = [ kalyx.homeManagerModules.default kyler.homeManagerModules.default ];
            configuration = ./hosts/systems/citadel-core;
            roles = [ ./hosts/roles/universal.nix ./hosts/roles/pc.nix ];
            hardware = ./hosts/systems/citadel-core/hardware.nix;
            stateVersion = "24.05";
            hostPlatform = "x86_64-linux";
            users = {
              george = {
                groups = [ "networkmanager" "wheel" "dialout" ] ++ kalyx.universalGroups ++ kalyx.adminGroups;
                noSudoPassword = true; # Set this to true if you dont want sudo to prompt you for a password.
                configuration = ./homes/users/george/citadel-core.nix;
                roles = [ ./homes/roles/universal.nix ./homes/roles/pc.nix ];
              };
            };
          };
        };
      });
}
