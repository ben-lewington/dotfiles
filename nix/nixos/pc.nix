{ config, pkgs, ... }:
{
    networking = {
        hostName = "pc";
        wireless.iwd.enable = true;
        networkmanager = {
            enable = true;
            wifi.backend = "iwd";
        };
        firewall.allowedTCPPorts = [ 4321 ];
    };
    time.timeZone = "Europe/London";

    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "gb";
        variant = "";
        options = "grp:alts_toggle";
    };

    # Configure console keymap
    console.keyMap = "uk";

    fonts.packages = with pkgs; [
        nerdfonts
    ];
}
