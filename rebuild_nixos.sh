#!/usr/bin/env bash
set -euo pipefail

FLAKE_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo nixos-rebuild switch --flake "$FLAKE_DIR#pc"
home-manager switch --flake "$FLAKE_DIR#ben"
