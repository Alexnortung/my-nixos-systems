{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      pidgin-with-plugins = super.pidgin.override {
        plugins = with pkgs; [
          telegram-purple
        ];
      };
    })
  ];
}
