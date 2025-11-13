{ _, pkgs, ... }:
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

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;
          # When enabled other devices can connect faster to us, however
          # the tradeoff is increased power consumption. Defaults to
          # 'false'.
          FastConnectable = true;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };

    # man configuration.nix / https://nixos.org/nixos/options.html
    system.stateVersion = "23.05";
}
