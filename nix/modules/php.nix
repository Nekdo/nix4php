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
      phpPackage = pkgs.php;
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

        # onlySSL = true;
        # enableACME = true;
      };
    };

    users.users = {
      ${app} = {
        isNormalUser = true;
        createHome = true;
        home = dataDir;
        group  = app;

        openssh.authorizedKeys.keyFiles = [
          ../ssh-keys/honzk.pub
        ];
      };
    };
    users.groups.${app} = {};
  };
}
