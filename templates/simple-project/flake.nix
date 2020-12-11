{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";

    nix4php.url = "github:Nekdo/nix4php";

    nixpkgs-1803 = {
      url = "github:NixOS/nixpkgs/release-18.03";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix4php, ... } @inputs: (
    {
      overlay = final: prev: (
        let
          pkgs-1803 = import inputs.nixpkgs-1803 { system = final.system; };
        in {
          php56 = pkgs-1803.php56;
          nodejs-8_x = pkgs-1803.nodejs-8_x;
        }
      );

      nixosConfigurations = {
        dev = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nix4php.nixosModules.phpDevMachine
            ./nix/modules/nix4php.nix
          ];
        };
      };
    } // (
      let
        supportedSystems = [ "x86_64-linux" ];
      in flake-utils.lib.eachSystem supportedSystems (system:
        let
          pkgs = import nixpkgs {
            overlays = [ self.overlay ];
            inherit system;
          };
        in {
          packages = {
            dev-vm = self.nixosConfigurations.dev.config.system.build.vm;
          };

          devShell = pkgs.mkShell {
            buildInputs =  [
              pkgs.jq
              pkgs.php56
              pkgs.nodejs-8_x
            ];

            shellHook = ''
              export TEST_ENV_VAR=foo
            '';
          };
        }
      )
    )
  );
}