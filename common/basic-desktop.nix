{ pkgs, ... }:

{
  imports = [
    ./overlays/st.nix
    ./overlays/dmenu.nix
  ];

  hardware.opengl = {
    enable = true;
  };

  xdg = {
    mime.enable = true;
    icons.enable = true;
    menus.enable = true;
  };
}
