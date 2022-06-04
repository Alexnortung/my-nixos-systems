{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [
  ];
  nixpkgs.overlays = [
    (self: super: {
      st = super.st.overrideAttrs (oldAttrs : rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
        configFile = super.writeText "config.h" (builtins.readFile ../config/st-config.h);
        postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
        patches = [
          # Desktop entry - gives an icon
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/desktopentry/st-desktopentry-0.8.4.diff";
            sha256 = "0v0hymybm2yplrvdjqysvcyhl36a5llih8ya9xjim1fpl609hg8y";
          })
          # More icon
          # (super.fetchpatch {
          #   url = "http://st.suckless.org/patches/netwmicon/st-netwmicon-0.8.4.diff";
          #   sha256 = "0gnk4fibqyby6b0fdx86zfwdiwjai86hh8sk9y02z610iimjaj1n";
          # })
          # Scrollback
          # (super.fetchpatch {
          #   url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.4.diff";
          #   sha256 = "0valvkbsf2qbai8551id6jc0szn61303f3l6r8wfjmjnn4054r3c";
          # })
          # Alpha
          # (super.fetchpatch {
          #   url = "https://st.suckless.org/patches/alpha/st-alpha-0.8.2.diff";
          #   sha256 = "158k93bbgrmcajfxvkrzfl65lmqgj6rk6kn8yl6nwk183hhf5qd4";
          # })
          # Ligatures
          # (super.fetchpatch {
          #   url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-scrollback-20200430-0.8.3.diff";
          #   sha256 = "gO6KSsmnns2gD3LTCiKSOJ/vlqg2r0lZ9AoNf9AidX8=";
          # })
          # OR
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/ligatures/0.8.4/st-ligatures-20210824-0.8.4.diff";
            sha256 = "SLevASYfie2tDt2Aln+vNY4GEhB7DIzmrtP/wjxt59c=";
          })
          # Anysize
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/anysize/st-anysize-0.8.4.diff";
            sha256 = "2uxCn9HtSM44poIVOPm4YwGXynN50OIE/HcsnW2cHyo=";
          })
          # Vercenter
          (super.fetchpatch {
            url = "https://st.suckless.org/patches/vertcenter/st-vertcenter-20180320-6ac8c8a.diff";
            sha256 = "0q1ka6gpxmflsmxy1790pjmvz79p1qjafm1g1ck6ixlkc9ls9rh4";
          })
          # w3m
          # (super.fetchpatch {
          #   url = "https://st.suckless.org/patches/w3m/st-w3m-0.8.3.diff";
          #   sha256 = "nVSG8zuRt3oKQCndzm+3ykuRB1NMYyas0Ne3qCG59ok=";
          # })
        ];
      });
    })
  ];
}
