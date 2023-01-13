{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  environment.variables = {
    NIX_LD = "${pkgs.runCommand "ld.so" {} ''
      ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out
    ''}";
  };
}
