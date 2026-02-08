{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      user = "ivan";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations =
        let
          inherit (nixpkgs) lib; # dont use "nixpkgs.lib", just use "lib"
          hostNames = [
            "nixos-main"
            "nixos-school"
          ];
          commonModules = [
            ./system/main.nix
          ];
        in

        lib.pipe hostNames [
          (map (
            hostName:
            lib.nameValuePair hostName (
              lib.nixosSystem {
                specialArgs = {
                  inherit inputs;
                  inherit pkgs-unstable;
                  inherit home-manager;
                  inherit user;
                  inherit hostName;
                };
                modules = commonModules ++ [
                  { networking.hostName = hostName; } # set the hostname
                  (./. + "/hosts/${hostName}/configuration.nix") # to get a absolute path

                  home-manager.nixosModules.home-manager
                  {
                    # make home-manager as a module of nixos
                    # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
                    home-manager = {
                      useUserPackages = true; # Packages install to /etc/profiles
                      useGlobalPkgs = true; # Use global package definitions
                      backupFileExtension = "backup"; # backup file instead of overriding it

                      users.${user} = import ./home/home.nix; # path of the home

                      extraSpecialArgs = {
                        # to pass arguments to home.nix
                        inherit inputs;
                        inherit user;
                        inherit hostName;
                      };
                    };
                  }
                ];
              }
            )
          ))
          lib.listToAttrs
        ];

      # equivalent to something like this :
      # ${hostName} = nixpkgs.lib.nixosSystem {
      #   ...
      # };
      # ...
    };
}
