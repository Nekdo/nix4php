{ pkgs, ... }: {
  imports = [
    ./php.nix
    ./mysql.nix
  ];

  config = {
    environment.systemPackages = [
      pkgs.htop
      pkgs.iptables
    ];
  };
}
