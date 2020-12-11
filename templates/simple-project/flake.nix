{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

    nix4php.url = "github:Nekdo/nix4php/work";

    nixpkgs-1803 = {
      url = "github:NixOS/nixpkgs/release-18.03";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix4php, ... } @inputs: (
    {
      overlay = final: prev: (
        let
          pkgs-1803 = import inputs.nixpkgs-1803 { system = final.system; };
        in {
          php56 = pkgs-1803.php56;
          nodejs-8_x = pkgs-1803.nodejs-8_x;
        }
      );
    } //
    {
      nixosConfigurations = {
        dev = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nix4php.nixosModules.php-dev-machine
            ./nix/modules/nix4php.nix
          ];
        };
      };

      packages."x86_64-linux" = {
        dev-vm = self.nixosConfigurations.dev.config.system.build.vm;
      };
    }
  );
}