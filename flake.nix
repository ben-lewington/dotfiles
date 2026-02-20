{
  description = "Ben's NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    parallel-launcher = pkgs.callPackage ./nix/flakes/parallel-launcher/default.nix { };

    ampShim = pkgs.writeShellScriptBin "amp" ''
      set -euo pipefail
      exec ${pkgs.pnpm}/bin/pnpx @sourcegraph/amp@latest --ide
    '';

    claudeShim = pkgs.writeShellScriptBin "claude" ''
      set -euo pipefail
      exec ${pkgs.pnpm}/bin/pnpx @anthropic-ai/claude-code@latest
    '';
  in {
    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./nix/nixos/configuration.nix
        { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }
      ];
    };

    homeConfigurations."ben" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./nix/home-manager/home.nix
        {
          home.packages = [
            parallel-launcher
            ampShim
            claudeShim
            pkgs.pnpm
            pkgs.nodejs
          ];
        }
      ];
    };
  };
}
