{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-1803 = {
      url = "github:NixOS/nixpkgs/release-18.03";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-1803, flake-utils }:
    let
      supportedSystems = "x86_64-linux";
      forAllSystems = f: (nixpkgs.lib.genAttrs supportedSystems (system: f system));
    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        #  import nixpkgs {
        #   inherit system;
        #   overlays = [ self.overlays.${system}.legacy ];
        # };
        pkgs-1803 = import nixpkgs-1803 { inherit system; };

        php56 = pkgs-1803.php56;
        nodejs_8 = pkgs-1803.nodejs-8_x;
      in {
        devShell = pkgs.mkShell {
          buildInputs =  [
            php56
            nodejs_8

            pkgs.jq
          ];

          shellHook = ''
            export TEST_ENV_VAR=foo
          '';
        };

        nixosConfigurations = {
          dev = { ... }: {
            imports = [
              ./nix/modules/dev-machine.nix
              "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
            ];
          };
          nixos = { ... }: {
            imports = [
              ./nix/modules/host-machine.nix
              "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
            ];
          };
        };

        packages = let
          nixos = c: (import "${nixpkgs}/nixos" {
            inherit system;
            configuration = c;
          });
        in {
          dev-vm = (nixos self.nixosConfigurations.${system}.dev).vm;
          host-vm = (nixos self.nixosConfigurations.${system}.nixos).vm;

          # all-pkg-versions = import ./nix/generate-versions.nix { inherit nixpkgs system; };
        };
      }
    ) // {
      defaultTemplate = self.templates.simple-project;

      templates = {
        simple-project = {
          description = "Template for simple PHP project";
          path = ./templates/simple-project;
        };
      };
    };
}
