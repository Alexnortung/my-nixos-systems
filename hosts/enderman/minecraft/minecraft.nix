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
  whitelist = lib.importJSON ./minecraft-whitelist.json;
in
{
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
        inherit whitelist;
        enable = true;
        # package = pkgs.vanillaServers.vanilla-1_21;
        package = inputs.minecraft-servers.legacyPackages.${system}.vanillaServers.vanilla-1_21;
        # package = pkgs.fabricServers.fabric-1_21;
        jvmOpts = "-Xms2G -Xmx8G";
        serverProperties = sharedProperties // {
          level-seed = "2529419826";
        };
      };
    };
    # declarative = true;
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
