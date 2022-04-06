{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      dmenu = super.dmenu.overrideAttrs (oldAttrs : rec {
        #postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        configFile = super.writeText "config.h" (builtins.readFile ../config/dmenu-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
        patches = [
          #(super.fetchpatch {
          #  url = "https://tools.suckless.org/dmenu/patches/case-insensitive/dmenu-caseinsensitive-5.0.diff";
          #  sha256 = "0bb0iwv8d53dibzqc307y3z852whwxjzjrxkbs07cs5y3c2l98ay";
          #})
        ];
      });
    })
  ];
}
