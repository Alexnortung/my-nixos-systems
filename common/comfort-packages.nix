{ pkgs, config, ... }:

{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Alexander Nortung";
        email = "alex_nortung@live.dk";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
      alias = {
        st = "status";
        co = "checkout";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        hale = "pull";
        puff = "push";
        hent = "fetch";
        skyd = "branch";
        forgren = "branch";
        fastlag = "commit";
        flet = "merge";
        gem = "stash";
        klandre = "blame";
        marker = "tag";
        klon = "clone";
        tilfoj = "add";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    bash
    lm_sensors
    gnumake
    zip unzip
    croc
    nmap
    vim
    pciutils
    htop
    neofetch
  ];
}
