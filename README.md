# nix4php

Development environment for PHP projects.

You need to have [nix with flakes](https://nixos.wiki/wiki/Flakes) support installed.

## Initialize PHP Project

    $ nix flake init -t 'github:Nekdo/nix4php'
    $ nix develop # or direnv allow

## Run dev VM

    $ bash run-dev-vm.sh
