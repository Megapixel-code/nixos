{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # quickshell = {
    #   # add ?ref=<tag> to track a tag
    #   url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

    #   # THIS IS IMPORTANT
    #   # Mismatched system dependencies will lead to crashes and other issues.
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: 
  let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { 
         inherit inputs;
         inherit pkgs-unstable;
      };

      modules = [
        ./system/configuration.nix
        ./pkgs/default.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.ivan = import ./home/default.nix;

          home-manager.extraSpecialArgs = { inherit inputs; }; # to pass arguments to home.nix
        }

      ];
    };
  };
}
