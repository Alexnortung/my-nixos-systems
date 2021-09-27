{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Required tools
    git
    curl
    # Futhark
    futhark
    # C
    gcc
    # Rust
    rustc
    rustup
    rls
    cargo
    rustfmt
    # Python
    pythonFull
    python3
  ];
}

