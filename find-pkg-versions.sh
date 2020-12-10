#!/bin/bash

PKG_NAME="$1"

nix eval .#packages.x86_64-linux.all-pkg-versions --apply "f: f.\"${PKG_NAME}\"" --impure --json | jq .

