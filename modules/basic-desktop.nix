{ pkgs, ... }:

{
  imports = [
    # ../overlays/st.nix
    ../overlays/dmenu.nix
    ../overlays/dwm.nix
    ../overlays/slock.nix
    ./battery-notifier.nix
    ./bg-setter.nix
  ];

  fonts.packages = with pkgs; [
    fira-code
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    #s3tcSupport = true;
    driSupport32Bit = true;
  };

  services.picom = {
    enable = true;
  };

  services.gnome.gnome-keyring = {
    enable = true;
  };

  gtk.iconCache.enable = true;

  xdg = {
    mime.enable = true;
    icons.enable = true;
    menus.enable = true;
  };

  environment.etc."xdg/alacritty/alacritty.yml".source = ../config/alacritty.yml;

  environment.variables = {
    # XDG_CONFIG_HOME = "/etc/xdg/"
  };

  environment.systemPackages = with pkgs; [
    playerctl # used by dmw config
    feh # Image viewer and background setter
    alacritty
  ];
}
