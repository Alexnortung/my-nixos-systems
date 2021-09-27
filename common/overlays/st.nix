{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      st = super.st.overrideAttrs (oldAttrs : rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
        configFile = super.writeText "config.h" (builtins.readFile ./config/st-config.h);
        postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        patches = [
          # Scrollback
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.4.diff";
            sha256 = "bGRSALFWVuk4yoYON8AIxn4NmDQthlJQVAsLp9fcVG0=";
          })
          # Alpha
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
            sha256 = "pOHiIBwoTG4N9chOM7ORD1daDHU/z92dVKzmt9ZIE5U=";
          })

          #(fetchpatch {
          #  url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
          #  sha256 = "9c5b4b4f23de80de78ca5ec3739dc6ce5e7f72666186cf4a9c6b614ac90fb285";
          #})
          # Ligatures
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-alpha-scrollback-20200430-0.8.3.diff";
            sha256 = "RyjaEwBN+D73YrDJqJ4z7v+AzteRMYD2IHqG78Kgzvg=";
          })
        ];

      });
    })
  ];
}
