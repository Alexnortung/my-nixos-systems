{ pkgs, ... }:

{
  imports = [
    ./overlays/st.nix
    ./overlays/dmenu.nix
    ./overlays/dwm.nix
    ./modules/battery-notifier.nix
    ./modules/bg-setter.nix
  ];

  hardware.opengl = {
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

  environment.systemPackages = with pkgs; [
    playerctl # used by dmw config
  ];
}
