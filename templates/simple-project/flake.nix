{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  };

  outputs = { self, nixpkgs } @inputs: {
    foo = inputs;

    nixosConfigurations.dev-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (import ./nix/modules/dev-machine.nix)
        "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
      ];
    };
  };
}