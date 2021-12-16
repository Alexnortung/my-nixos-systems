{ pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
  };

  xdg = {
    mime.enable = true;
    icons.enable = true;
    menus.enable = true;
  };
}
