{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nordic
    lxappearance
  ];

  environment.etc = {
    # "xdg/gtk-2.0".source = pkgs.nordic;
    # "xdg/gtk-3.0".source = pkgs.nordic;
    # "xdg/gtk-4.0".source = pkgs.nordic;
  };
}
