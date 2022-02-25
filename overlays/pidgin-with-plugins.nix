{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      pidgin-with-plugins = super.pidgin-with-plugins.override {
        plugins = with pkgs; [
          telegram-purple
        ];
      };
    })
  ];
}
