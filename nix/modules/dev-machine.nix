{ pkgs, config, ... }: {
  imports = [
    ./php.nix
    ./mysql.nix
  ];

  config = {
    environment.systemPackages = [
      pkgs.htop
      pkgs.iptables
      pkgs.mariadb
    ];

    users.mutableUsers = false;

    users.users.root = {
      openssh.authorizedKeys.keyFiles = config.nix4php.sshAuthorizedKeyFiles;
    };

    networking.firewall.enable = false;

    services.openssh.enable = true;
  };
}
