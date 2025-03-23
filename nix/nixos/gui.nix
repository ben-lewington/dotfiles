{ config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        grim
        slurp
        woomer
    ];

    programs.sway = {
        enable = true;
        package = pkgs.swayfx;
        wrapperFeatures.gtk = true;

        extraPackages = with pkgs; [
            grim
            slurp
            wl-clipboard
            mako
            wofi
            waypaper
            swayidle
            swaylock
            swww
            waybar
            pavucontrol
            xfce.thunar
            networkmanagerapplet
        ];
    };

    services = {
        gnome.gnome-keyring.enable = true;
        displayManager.ly = {
            enable = true;
            settings = {
                animation = "doom";
            };
        };
    };
}
