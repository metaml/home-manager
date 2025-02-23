{
  description = "home manager configuration of ml";

  inputs = {
    # specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    execpermfix.url = "github:lpenz/execpermfix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
    in rec {
      homeConfigurations."ml" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  
  # outputs = { nixpkgs, home-manager, execpermfix, flake-utils, ... }:
  #   flake-utils.lib.eachDefaultSystem( system:
  #     let
  #       pkgs = nixpkgs.legacyPackages.${system};
  #       system = "x86_64-linux";
  #     in rec {
  #       homeConfigurations."ml" = home-manager.lib.homeManagerConfiguration {
  #         inherit pkgs;
  #         modules = [ ./home.nix ];
  #       };
  #     }
  #   );
}
