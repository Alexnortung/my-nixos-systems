{ pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
}
