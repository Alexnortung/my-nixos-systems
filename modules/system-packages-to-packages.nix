{ config, lib, ... }:
with lib;

let
  cfg = config.environment.systemPackages;
in
{
  options = {
    environment.systemPackages = mkOption {
      default = [];
      type = types.listOf types.package;
    };
  };
  config = {
    environment.packages = cfg.environment.systemPackages;
  };
}
