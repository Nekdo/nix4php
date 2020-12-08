{ pkgs, ... }:
let
  userName = "phpdemo";
  dbName = "phpdemo";
in {
  config = {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      bind = "127.0.0.1";

      ensureUsers = [
        {
          name = userName;
          ensurePermissions = {
            "${dbName}.*" = "ALL PRIVILEGES";
          };
        }
      ];

      ensureDatabases = [
        dbName
      ];
    };
  };
}
