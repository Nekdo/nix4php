{ config, ... }:
{
  config = {
    nix4php = {
      sshAuthorizedKeyFiles = [
        ../ssh-keys/user.key.pub
      ];

      appName = "php-demo";

      domain = "php-demo.example.com";
    };
  };
}
