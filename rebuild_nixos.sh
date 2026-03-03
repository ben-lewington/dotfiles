#!/usr/bin/env bash
set -euo pipefail

FLAKE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "$@ $#"

home-manager switch --flake "$FLAKE_DIR#ben"
if [[ "$#" -ge 1 ]]; then exit 0; fi

sudo nixos-rebuild switch --flake "$FLAKE_DIR#pc"
