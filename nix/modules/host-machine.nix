{ ... }:

{
  config = {
    users = {
      mutableUsers = false;

      users.nixos = {
        openssh.authorizedKeys.keyFiles = [
          ~/.ssh/id_rsa.pub
        ];
      };
    };
  };
}
