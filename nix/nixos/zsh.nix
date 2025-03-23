{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        grml-zsh-config
        zsh
    ];

    programs.zsh = {
        enable = true;
        interactiveShellInit = ''
            source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
        '';
        promptInit = "";
    };
}
