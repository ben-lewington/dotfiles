{ config, pkgs, ... }:
{
  imports = [
    ./nvim.nix
    ./tmux.nix
    ./zellij.nix
  ];

  home = {
    username = "ben";
    homeDirectory = "/home/ben";
    packages = with pkgs; [
      ghostty
      tmux
      git
      htop
    ];
    pointerCursor = {
      hyprcursor.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
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

    includes = [
      {
        contents = {
          user = {
            email = "ben@addit.ai";
          };
          core = {
            sshCommand = "ssh -i ~/.ssh/id_ed25519_addit";
          };
        };
        condition = "hasconfig:remote.*.url:git@github.com:addit-ai/*";
      }
    ];
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
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
    };
  };

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  wayland.windowManager.hyprland.enable = false;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland/hyprland.conf;

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
