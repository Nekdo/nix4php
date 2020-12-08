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
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-1803 = import nixpkgs-1803 { inherit system; };

        php = pkgs-1803.php56;
        # php = pkgs.php74;
        node = pkgs.nodejs-10_x;
      in {
        devShell = pkgs.mkShell {
          buildInputs =  [
            php
            node
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
        };

        packages = let
          nixos = c: (import "${nixpkgs}/nixos" {
            inherit system;
            configuration = c;
          });
        in {
          dev-vm = (nixos self.nixosConfigurations.${system}.dev).vm;
        };
      }
    );
}
