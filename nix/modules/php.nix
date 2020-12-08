{ pkgs, lib, config, ... }:
let
  app = "phpdemo";
  domain = "${app}.example.com";
  dataDir = "/srv/http/${domain}";
in {
  config = {
    services.phpfpm.pools.${app} = {
      user = app;
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
        };
      phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
    };
    services.nginx = {
      enable = true;
      virtualHosts.${domain}.locations."/" = {
      root = dataDir;
      extraConfig = ''
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:${config.services.phpfpm.pools.${app}.socket};
        include ${pkgs.nginx}/conf/fastcgi_params;
        include ${pkgs.nginx}/conf/fastcgi.conf;
      '';
      };
    };

    users.mutableUsers = false;
    users.users = {
      ${app} = {
        isSystemUser = true;
        createHome = true;
        home = dataDir;
        group  = app;

        password = "heslo";

        openssh.authorizedKeys.keyFiles = [
          ~/.ssh/id_rsa.pub
        ];
      };

      root = {
        password = "heslo";
      };
    };
    users.groups.${app} = {};

    # fileSystems.app-dir = {
    #   mountPoint = dataDir;
    #   device = "app";
    #   fsType = "9p";
    #   options = [ "trans=virtio" "version=9p2000.L" ];
    # };
    # networking.firewall.enable = false;
  };
}
