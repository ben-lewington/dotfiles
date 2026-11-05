#!/usr/bin/env bash
set -euo pipefail

FLAKE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "$@ $#"

if [[ "$#" -ge 1 ]]; then
    home-manager switch --flake "$FLAKE_DIR#ben"
else
    sudo nixos-rebuild switch --flake "$FLAKE_DIR#pc"
fi
