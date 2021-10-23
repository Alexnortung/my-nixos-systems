{ pkgs, ... }:

{
  users = {
    users = {
      alexander-admin = {
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ];
      };
    };
  };
}
