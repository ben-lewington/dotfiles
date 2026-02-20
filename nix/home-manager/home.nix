{ config, pkgs, ... }:
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
        ];
    };

    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "Ben Lewington";
                email = "ben.lewington91@ntlworld.com";
            };
            core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
            init.defaultBranch = "main";
            alias.lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
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
