# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

let
  futhark-vim = pkgs.vimUtils.buildVimPlugin {
    name = "futhark-vim";
    src = pkgs.fetchFromGitHub {
      owner = "BeneCollyridam";
      repo = "futhark-vim";
      rev = "fd7d053c74f150712eaa73999f44a3f95c8f08ff";
      sha256 = "17iwpqxkvflcimc066n5ljjbx603hpaqzk271r37qxdvk58jpn0w";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = builtins.readFile ./config/init.vim;
      packages.nix = with pkgs.vimPlugins; {
        start = [
          vim-surround # Shortcuts for setting () {} etc.
          coc-nvim coc-git coc-highlight coc-python coc-rls coc-vetur coc-vimtex coc-yaml coc-html coc-json # auto completion
          vim-nix # nix highlight
          vim-javascript # javascript highlight
          vim-yaml # yaml highlight
          vimtex # latex stuff
          fzf-vim # fuzzy finder through vim
          nerdtree # file structure inside nvim
          rainbow # Color parenthesis
          futhark-vim
        ];
        opt = [];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    nodejs
  ];
  #environment.systemPackages = with pkgs; [
  #  (neovim.override {
  #    vimAlias = true;
  #    configure = {
  #      customRC = builtins.readFile ./config/init.vim;
  #      packages.myPlugins = with pkgs.vimPlugins; {
  #        start = [
  #          vim-surround # Shortcuts for setting () {} etc.
  #          coc-nvim coc-git coc-highlight coc-python coc-rls coc-vetur coc-vimtex coc-yaml coc-html coc-json # auto completion
  #          vim-nix # nix highlight
  #          vimtex # latex stuff
  #          fzf-vim # fuzzy finder through vim
  #          nerdtree # file structure inside nvim
  #          rainbow # Color parenthesis
  #        ];
  #        opt = [];
  #      };
  #    };
  #  })
  #];
}
