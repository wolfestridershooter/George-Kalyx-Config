{
  description = "Template config using kalyx.";

  inputs = {
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
  };

  outputs = inputs: with inputs;
  let
    specialArgs = { inherit inputs self; };
    system = "x86_64-linux";

    mkNixos = system: sysname: roles: extraModules: nixpkgs.lib.nixosSystem {
      inherit specialArgs system;
      modules = [
        home-manager.nixosModules.home-manager
        { networking.hostName = "${sysname}"; }
        (./hosts/systems/. + builtins.toPath "/${sysname}")
        ./hosts/universal.nix
        kalyx.nixosModules
      ] 
      ++ (map (x: ./hosts/roles/. + builtins.toPath ("/" + x + ".nix")) roles)
      ++ extraModules;
    };

    mkHome = usrname: sysname: home-manager.lib.homeManagerConfiguration {
      stateVersion = "23.11";
      extraSpecialArgs = specialArgs;
      pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      configuration.imports = [
        (./homes/. + builtins.toPath "/${usrname}/${sysname}.nix")
      ];
      modules = [
        kalyx.homeManagerModules
      ];
    };

    mkUser = usrname: groups: disablesudopassword: ( sysname: {
      users.users.${usrname} = {
        isNormalUser = true;
        description = "${usrname}";
        extraGroups = groups;
      };

      security.sudo.extraRules = nixpkgs.lib.mkIf disablesudopassword [
        { users = [ "${usrname}" ];
          commands = [
            { command = "ALL" ;
              options= [ "NOPASSWD" ];
            }
          ];
        }
      ];

      kalyx.home-manager = {
        enable = true;
        users.${usrname} = {
          enable = true;
          configs = [ 
            (./homes/. + builtins.toPath "/${usrname}/${sysname}.nix")
          ] ++ kalyx.homeModulePaths;
        };
      };
    });
  in
  {
    homeConfigurations = {
      "username@systemname" = mkHome "username" "systemname";
    };

    nixosConfigurations = let
      username = mkUser "username" [ "wheel" "dialout" "networkmanager" ] true;
    in {
      systemname = mkNixos "x86_64-linux" "systemname" [ "pc" ] [ (username "systemname") ];
    };
  };
}