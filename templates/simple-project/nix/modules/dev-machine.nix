{ config, ... }:
{
    config = {
        php-dev = {
            sshAuthorizedKeyFiles = [
                ../ssh-keys/user.key.pub
            ];

            appName = "php-demo";

            domain = "php-demo.example.com";
        };
    };
}
