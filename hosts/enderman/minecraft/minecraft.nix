{ pkgs
, lib
, inputs
, ...
}@args:
let
  system = "x86_64-linux";
  sharedProperties = {
    server-ip = "0.0.0.0";
    enable-query = false;
    enable-jmx-monitoring = false;
    motd = "Block Busters";
    "query.port" = 25565;
    texture-pack = "";
    network-compression-threshold = 256;
    rate-limit = 0;
    max-tick-time = -1;
    require-resource-pack = false;
    resource-pack-sha1 = "";
    generator-settings = "";
    use-native-transport = true;
    enable-status = true;
    enable-command-block = false;
    gamemode = "survival";
    force-gamemode = false;
    level-name = "world";
    pvp = true;
    generate-structures = true;
    difficulty = "hard";
    max-players = 12;
    online-mode = true;
    allow-flight = false;
    view-distance = 18;
    max-build-height = 256;
    allow-nether = true;
    server-port = 25565;
    op-permission-level = 4;
    player-idle-timeout = 0;
    debug = false;
    hardcore = false;
    white-list = true;
    broadcast-console-to-ops = true;
    boradcast-rcon-to-ops = true;
    spawn-npcs = true;
    spawn-animals = true;
    snooper-enabled = true;
    text-filtering-config = "";
    function-permission-level = 2;
    level-type = "default";
    spawn-monsters = true;
    spawn-protection = 0;
    max-world-size = 29999984;
    sync-chunk-writes = true;
    enable-rcon = true;
    "rcon.port" = 25575;
    "rcon.password" = "rconpass2";
    prevent-proxy-connection = false;
    entity-broadcast-range-percentage = 100;
  };
  # whitelist = lib.importJSON ./minecraft-whitelist.json;
  whitelist = null;
in
{
  systemd.services.minecraft-server-block-busters-1-21 = {
    startLimitIntervalSec = lib.mkForce 15;
  };
  systemd.services.minecraft-server-block-busters-1-21-test = {
    startLimitIntervalSec = lib.mkForce 15;
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/var/lib/minecraft-servers";
    servers = {
      block-busters = {
        inherit whitelist;
        enable = false;
        package = pkgs.fabricServers.fabric-1_20_1;
        # dataDir = "/data/data1/var/lib/minecraft2";
        jvmOpts = "-Xms2G -Xmx8G";
        serverProperties = sharedProperties // {
          # level-seed = "-4846211776141860780";
          level-seed = "-433856114";
        };
        symlinks = {
          mods =
            pkgs.linkFarmFromDrvs "mods"
              (builtins.attrValues {
                Lithium = (
                  pkgs.fetchurl {
                    url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/ZSNsJrPI/lithium-fabric-mc1.20.1-0.11.2.jar";
                    sha256 = "1ycdvrs46bbdxsa6i38sfx70v47nvzzbmblfpy3hq3k8blsrbid0";
                  }
                );
              });
        };
      };

      block-busters-1-21 = {
        enable = true;
        # package = pkgs.vanillaServers.vanilla-1_21;
        # package = inputs.minecraft-servers.legacyPackages.${system}.fabricServers.fabric-1_21;
        package = inputs.minecraft-servers.legacyPackages.${system}.vanillaServers.vanilla-1_21;
        # package = pkgs.fabricServers.fabric-1_21;
        jvmOpts = "-Xms2G -Xmx8G";
        serverProperties = sharedProperties // {
          level-seed = "2529419826";
        };
      };

      block-busters-1-21-test = {
        enable = true;
        # package = pkgs.vanillaServers.vanilla-1_21;
        package = inputs.minecraft-servers.legacyPackages.${system}.fabricServers.fabric-1_21;
        # package = inputs.minecraft-servers.legacyPackages.${system}.vanillaServers.vanilla-1_21;
        # package = pkgs.fabricServers.fabric-1_21;
        jvmOpts = "-Xms2G -Xmx8G";
        serverProperties = sharedProperties // {
          level-seed = "2529419826";
          server-port = 25566;
        };

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
            FabricApi = (
              pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/1cXs6RWI/fabric-api-0.100.3%2B1.21.jar";
                sha256 = "sha256-K4q84mbCBprhFlo5lRZOv6tVWpXnvCQPIhynIionNZU=";
              }
            );
            InvView = (
              pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/jrDKjZP7/versions/LNGVFn7g/InvView-1.4.15-1.20.5%2B.jar";
                sha256 = "sha256-fsEUjewyHKVg/0RJcpTdl0ClWSRj3ApU8Qv+AxIFZJE=";
              }
            );
          });

          # "world/datapacks/Deactivate-Portals.zip" = pkgs.fetchurl {
          #   url = "https://cdn.modrinth.com/data/L83JDWD9/versions/bOGaf8Q5/Deactivate-Portals.zip";
          #   sha256 = "sha256-14sYSQAmixq1i6UP98eKQ4X5EqilQtWaFXKigsKERWw=";
          # };
        };
      };
    };
    # declarative = true;
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
