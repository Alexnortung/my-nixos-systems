{ pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    openFirewall = true;

    extraComponents = [
      "default_config"
      "deluge"
      "met"
      "esphome"
      "homeassistant"
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
