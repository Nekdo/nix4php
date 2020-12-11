#!/bin/bash

set -eu


CONT_NAME=dev-vm

nixos-container create "$CONT_NAME" --flake .#dev-vm --ensure-unique-name

nixos-container start "$CONT_NAME"


echo "Web runs on \`http://${CONT_NAME}/\`"

