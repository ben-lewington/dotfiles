{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    grim
    slurp
    woomer
    wl-clipboard
    mako
    wofi
    waypaper
    swaylock
    swww
    waybar
    pavucontrol
    xfce.thunar
    networkmanagerapplet
  ];

  programs.hyprland = {
    enable = true;
    # ly exposes the UWSM session but cannot reliably start it here.
    # Keep only the plain Hyprland session, which loads ~/.config/hypr/hyprland.conf.
    withUWSM = false;
  };

  # programs.sway = {
  #     enable = true;
  #     package = pkgs.swayfx;
  #     wrapperFeatures.gtk = true;
  #
  #     extraPackages = with pkgs; [
  #         grim
  #         slurp
  #         wl-clipboard
  #         mako
  #         wofi
  #         waypaper
  #         swayidle
  #         swaylock
  #         swww
  #         waybar
  #         pavucontrol
  #         xfce.thunar
  #         networkmanagerapplet
  #     ];
  # };

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
