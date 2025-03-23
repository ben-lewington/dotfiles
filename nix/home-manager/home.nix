{ config, pkgs, ... }: {
    imports = [ ./nvim.nix  ./tmux.nix ];
    home.username = "ben";

    home.homeDirectory = "/home/ben";

    home.packages = with pkgs; [
        alacritty
        tmux
        git
        htop
    ];

    programs.git = {
        enable = true;
        userName = "Ben Lewington";
        userEmail = "ben.lewington1991@gmail.com";
        extraConfig = { core = { sshCommand = "ssh -i ~/.ssh/id_ed25519"; }; };

        includes = [ {
            contents = {
                user = { email = "ben@addit.ai"; };
                core = { sshCommand = "ssh -i ~/.ssh/id_ed25519_addit"; };
            };
            condition = "hasconfig:remote.*.url:git@github.com:addit-ai/*";
        } ];
    };

    programs.alacritty = {
        enable = true;
        settings = {
            general.live_config_reload = true;

            window.opacity = 0.85;
            window.resize_increments = true;
            font.normal = {
                family = "JetBrainsMono Nerd Font Mono";
                style = "Regular";
            };
            font.size = 9.5;
        };
    };

    # programs.home-manager.enable = true;
    home.stateVersion = "24.11";
}
