{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        configFile = super.writeText "config.h" (builtins.readFile ../config/dwm-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
        patches = [
          # alwaysfullscreen - focus does not drift off when in fullscreen
          # (super.fetchpatch {
          #   url = "https://dwm.suckless.org/patches/alwaysfullscreen/dwm-alwaysfullscreen-6.1.diff";
          #   sha256 = "1037m24c1hd6c77p84szc5qqaw4kldwwfzggyn6ac5rv8l47j057";
          # })
          ## Smart borders
          #(super.fetchpatch {
          #  url = "https://dwm.suckless.org/patches/smartborders/dwm-smartborders-6.2.diff";
          #  sha256 = "0chx3i2ddnx1i2c2hfp2m693khjfmfx2fmvwp6qa79jqymmlzdxs";
          #})
          # Systray
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/systray/dwm-systray-20230922-9f88553.diff";
            sha256 = "sha256-Kh1aP1xgZAREjTy7Xz48YBo3rhrJngspUYwBU2Gyw7k=";
          })
          # Pertag - gives each tag its own workspace
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/pertag/dwm-pertag-6.2.diff";
            sha256 = "8DmooU16+TGu+BzUzxdlbYaB12HSae/RO7fGfsC8IHM=";
          })
          # Hide vacant tags
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.3.diff";
            sha256 = "GBa4NOZFFQGiSsqgXWkFXzCQDeNmxJG0/g3ZYby0pnc=";
          })
        ];
      });
    })
  ];
}
