{ lib, ... }:

{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = lib.mkDefault "Alexander Nortung";
        email = lib.mkDefault "alex_nortung@live.dk";
      };
      init = {
        defaultBranch = lib.mkDefault "main";
      };
      pull = {
        rebase = lib.mkDefault true;
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
}
