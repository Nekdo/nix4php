{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        php = pkgs.php73;
        node = pkgs.nodejs-10_x;
      in {
        packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

        defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

        devShell = pkgs.mkShell {
          buildInputs =  [
            pkgs.vim
            php
            node
          ];

          shellHook = ''
            PS1="\n\[\033[1;32m\][nix develop:\w]\$\[\033[0m\]"
          '';
        };
      }
    );
}
