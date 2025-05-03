{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./gui.nix
        ./pc.nix
        ./zsh.nix
        ./containers.nix
    ];

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        neovim
        tmux
        git
        wget
        google-chrome
        brave
    ];

    users = {
        users.ben = {
            isNormalUser = true;
            description = "ben";
            extraGroups = [ "networkmanager" "wheel" ];
        };
        defaultUserShell = pkgs.zsh;
    };

    environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

    # man configuration.nix / https://nixos.org/nixos/options.html
    system.stateVersion = "23.05";
}
