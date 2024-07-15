{
  description = "home-manager";

  inputs = {
    nixpkgs      = { url = "nixpkgs/nixpkgs-unstable"; };
    utils        = { url = "github:numtide/flake-utils"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, utils, home-manager }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        homeConfigurations."ml" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cacert
            emacs
            git
            gnumake
            home-manager
          ];
          shellHook = ''
            export LANG=en_US.UTF-8
            export PS1="home-manager|$PS1"
          '';
        };
        devShell = self.devShells.${system}.default;
      }
    );
}
