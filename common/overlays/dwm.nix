{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs : rec {
        configFile = super.writeText "config.h" (builtins.readFile ../config/dwm-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
        patches = [
          # alwaysfullscreen - focus does not drift off when in fullscreen
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/alwaysfullscreen/dwm-alwaysfullscreen-6.1.diff";
            sha256 = "1037m24c1hd6c77p84szc5qqaw4kldwwfzggyn6ac5rv8l47j057";
          })
          ## Smart borders
          #(super.fetchpatch {
          #  url = "https://dwm.suckless.org/patches/smartborders/dwm-smartborders-6.2.diff";
          #  sha256 = "0chx3i2ddnx1i2c2hfp2m693khjfmfx2fmvwp6qa79jqymmlzdxs";
          #})
          # Systray
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.2.diff";
            sha256 = "1p1hzkm5fa9b51v19w4fqmrphk0nr0wnkih5vsji8r38nmxd4ydp";
          })
          # Pertag - gives each tag its own workspace
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/pertag/dwm-pertag-6.2.diff";
            sha256 = "8DmooU16+TGu+BzUzxdlbYaB12HSae/RO7fGfsC8IHM=";
          })
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.2.diff";
            sha256 = "1a3z9f2hd7602857v99hcyiw4sapsl7x5v612azani1plz6l6vbi";
          })
        ];
      });
    })
  ];
}
