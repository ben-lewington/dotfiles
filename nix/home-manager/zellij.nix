{ ... }:
{
    programs.zellij.enable = true;

    xdg.configFile."zellij/config.kdl".source = ./zellij/config.kdl;
    xdg.configFile."zellij/layouts/dev.kdl".source = ./zellij/layouts/dev.kdl;
}
