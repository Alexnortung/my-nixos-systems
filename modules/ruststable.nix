# Rquires the fenix overlay
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
  ];
}
