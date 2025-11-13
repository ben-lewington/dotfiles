{ config, pkgs, ... }:
let
    parallelLauncherFlake = builtins.getFlake "path:/home/ben/parallel-launcher";
in
{
    imports = [ ./nvim.nix  ./tmux.nix ];

    home = {
        username = "ben";
        homeDirectory = "/home/ben";
        packages = with pkgs; [
            ghostty
            tmux
            git
            htop
            parallelLauncherFlake.packages.${pkgs.system}.default
        ];
    };

    programs.git = {
        enable = true;
        userName = "Ben Lewington";
        userEmail = "ben.lewington91@ntlworld.com";
        extraConfig = {
            core = { sshCommand = "ssh -i ~/.ssh/id_ed25519"; };
            init.defaultBranch = "main";
        };

        includes = [ {
            contents = {
                user = { email = "ben@addit.ai"; };
                core = { sshCommand = "ssh -i ~/.ssh/id_ed25519_addit"; };
            };
            condition = "hasconfig:remote.*.url:git@github.com:addit-ai/*";
        } ];
    };

    programs.ghostty = {
        enable = true;
        settings = {
            font-size = 9;
            font-synthetic-style = false;
            alpha-blending = "linear-corrected";
            adjust-cell-width = "20%";
            adjust-cell-height = "8%";
            background-opacity = 0.90;
            theme = "Monokai Pro";
            keybind = "ctrl+shift+i=unbind";
            cursor-opacity = 0.50;
        };
    };

    programs.home-manager.enable = true;
    home.stateVersion = "24.11";
}
