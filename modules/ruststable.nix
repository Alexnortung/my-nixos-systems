# Rquires the fenix overlay
{ pkgs, ... }:

let
  fenixWithComps = pkgs.fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ];
  myFenix = pkgs.fenix.combine [
    fenixWithComps
    pkgs.fenix.targets.wasm32-unknown-unknown.stable.rust-std
  ];
in
{
  environment.systemPackages = with pkgs; [
    myFenix
  ];
}
