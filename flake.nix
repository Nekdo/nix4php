{
  description = "Support for development of PHP projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils } @inputs:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs =  [
            pkgs.jq
          ];
        };
      }
    ) // {
      nixosModules = {
        phpDevMachine = ./nix/modules/dev-machine.nix;
      };

      defaultTemplate = self.templates.simple-project;

      templates = {
        simple-project = {
          description = "Template for simple PHP project";
          path = ./templates/simple-project;
        };
      };
    };
}
