#!/bin/bash

set -eu


BIND_HOST="${1:-"127.0.0.10"}"


#
# Build the VM
#
mkdir -p results
nix build .#dev-vm -o results/dev-vm


#
# Run the VM
#
echo "To ssh to the machine run \`ssh -p 8022 phpdemo@${BIND_HOST}\`"
echo "Web runs on \`http://${BIND_HOST}:8080\`"

QEMU_NET_OPTS="hostfwd=tcp:$BIND_HOST:8022-:22,hostfwd=tcp:$BIND_HOST:8080-:80" ./results/dev-vm/bin/run-nixos-vm
