{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
	    url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager}:
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
	    useGlobalPkgs=true;   
            users.${username}= ./home.nix;
          };
        }
       ];
    };
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ 
        ./home.nix
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "22.11";
          };
        }
      ];
    };
  };
}
