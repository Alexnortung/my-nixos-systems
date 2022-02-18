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
    # rustc # use the one in nvim.nix instead
    #rustup
    #rls
    cargo
    rustfmt
    # Python
    pythonFull
    python3
  ];
}

