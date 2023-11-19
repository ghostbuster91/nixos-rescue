{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko }:
    let
      username = "kghost";
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.cartman = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/aspire/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.${username} = ./home.nix;
              extraSpecialArgs = { inherit username; };
            };
          }
        ];
      };

      nixosConfigurations.virtos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/virtos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              users.${username} = ./home.nix;
              extraSpecialArgs = { inherit username; };
            };
          }
          disko.nixosModules.disko
        ];
      };
      nixosConfigurations.deckard = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/deckard/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              userUserPackages = true;
              useGlobalPkgs = true;
              user.${username} = ./home.nix;
              extraSpecialArgs = { inherit username; };
            };
          }
          disko.nixosModules.disko
        ];
      };

      nixosConfigurations.kubuntu = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/kubuntu/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              userUserPackages = true;
              useGlobalPkgs = true;
              user.${username} = ./home.nix;
              extraSpecialArgs = { inherit username; };
            };
          }
          disko.nixosModules.disko
        ];
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration
        {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
          ];
          specialArgs = { inherit username; };
        };
    };
}
