{
  nixpkgs.overlays = [
    (self: super: {
      slock = super.slock.overrideAttrs (oldAttrs: rec {
        configFile = super.writeText "config.h" (builtins.readFile ../config/slock-config.h);
        postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
        patches = [
          (super.fetchpatch {
            url = "https://tools.suckless.org/slock/patches/squares/slock-squares-1.5.diff";
            sha256 = "sha256-rhCtp2d/+iwrf0Reml8FpYw3Q6W/vHj2TzebH8B7blU=";
          })
        ];
      });
    })
  ];
}
