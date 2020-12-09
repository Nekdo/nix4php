{ pkgs, ... }: {
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
      openssh.authorizedKeys.keyFiles = [
        ../ssh-keys/honzk.pub
      ];
    };

    networking.firewall.enable = false;

    services.openssh.enable = true;
  };
}
