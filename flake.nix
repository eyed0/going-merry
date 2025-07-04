{
  description = "A very basic flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri-working-tree.url = "github:sodiboo/niri/sodi-bonus-features";
    # niri-working-tree.flake = false;

    #chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # anyrun = {
    #   url = "github:anyrun-org/anyrun";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	  # # suyu switch imulator
	  # suyu.url = "git+https://git.suyu.dev/suyu/nix-flake";
    # suyu.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # TODO deploy-rs.url = "github:serokell/deploy-rs";
    
    # TODO xremap-flake.url = "github:xremap/nix-flake" # check vimjoyer vdo 

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
	    {
        packages.x86_64-linux.hello = pkgs.hello;
        packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; 
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            inputs.stylix.nixosModules.stylix
            inputs.agenix.nixosModules.default
            inputs.niri.nixosModules.niri
            #inputs.chaotic.nixosModules.default
          ];
        };

        homeConfigurations."heehaw" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            #inputs.stylix.homeManagerModules.stylix
            inputs.niri.homeModules.niri
            #inputs.zen-browser.packages."${system}".default
		      ];
		      extraSpecialArgs = { inherit inputs; };
        };
        
	    };  
}
