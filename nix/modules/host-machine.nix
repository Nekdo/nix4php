{ pkgs, ... }:

{
  config = {
    users = {
      mutableUsers = false;

      users = {
        nixos = {
          isNormalUser = true;

          openssh.authorizedKeys.keyFiles = [
            ../ssh-keys/honzk.pub
          ];
        };

        root = {
          openssh.authorizedKeys.keyFiles = [
            ../ssh-keys/honzk.pub
          ];
        };
      };
    };

    services.openssh.enable = true;

    networking.firewall.enable = false;

    environment.systemPackages = [
      pkgs.nixFlakes
      pkgs.direnv

      pkgs.htop
      pkgs.iptables
    ];
  };
}
