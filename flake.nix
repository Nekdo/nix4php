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

          shellHook = ''
            export TEST_ENV_VAR=foo
          '';
        };

        # packages = let
        #   nixos = c: (import "${nixpkgs}/nixos" {
        #     inherit system;
        #     configuration = c;
        #   });
        # in {
        #   dev-vm = (nixos self.nixosConfigurations.${system}.dev).vm;
        #   # host-vm = (nixos self.nixosConfigurations.${system}.nixos).vm;

        #   # all-pkg-versions = import ./nix/generate-versions.nix { inherit nixpkgs system; };
        # };
      }
    ) // {
      nixosModules = {
          php-dev-machine = ./nix/modules/dev-machine.nix;
          # nixos = { ... }: {
          #   imports = [
          #     ./nix/modules/host-machine.nix
          #     "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
          #   ];
          # };
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
