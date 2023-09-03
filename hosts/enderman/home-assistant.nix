{ pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true;

    extraComponents = [
      "sonos"
    ];

    config = {
      homeassistant = {
        unit_system = "metric";
      };
      default_config = {};
      met = {};
    };
  };
}
