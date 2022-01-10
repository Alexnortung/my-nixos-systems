{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs : rec {
        configFile = super.writeText "config.h" (builtins.readFile ../config/dwm-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
        patches = [
          # alwaysfullscreen - focus does not drift off when in fullscreen
          #(super.fetchpatch {
          #  url = "https://dwm.suckless.org/patches/alwaysfullscreen/dwm-alwaysfullscreen-6.1.diff";
          #  sha256 = "1037m24c1hd6c77p84szc5qqaw4kldwwfzggyn6ac5rv8l47j057";
          #})
          # Systray
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.2.diff";
            sha256 = "1p1hzkm5fa9b51v19w4fqmrphk0nr0wnkih5vsji8r38nmxd4ydp";
          })
        ];
      });
    })
  ];
}
