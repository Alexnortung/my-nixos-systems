{ pkgs
, lib
, ...
}: {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/data/data1/var/lib/minecraft-servers";
    servers = {
      block-busters = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_20_1;
        # dataDir = "/data/data1/var/lib/minecraft2";
        jvmOpts = "-Xms2G -Xmx8G";
        serverProperties = {
          server-ip = "0.0.0.0";
          #server-ip = "10.100.0.2";
          enable-query = false;
          enable-jmx-monitoring = false;
          motd = "Hi!";
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
          # level-seed = "-4846211776141860780";
          level-seed = "-433856114";
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
          spawn-protection = 16;
          max-world-size = 29999984;
          sync-chunk-writes = true;
          enable-rcon = false;
          "rcon.port" = 25575;
          prevent-proxy-connection = false;
          entity-broadcast-range-percentage = 100;
        };
        whitelist = {
          Yamse = "a09863fd-d715-4838-a8c2-e93be9eceb7c";
          Nollefyr = "94553a27-7088-4bc6-8c33-ad1fd79b591b";
          isso55 = "5dd48794-78f4-4beb-8eca-4b4bd7dcb0c5";
          Kasperlugter = "d077583b-90bd-4613-abb9-f5865011e41a";
          Mokkamussen = "f893734b-534c-4321-bb91-6eeb662c01ed";
          Null_Boi = "e9fdc0f4-7c45-406d-a2bc-34d059687c22";
          Nanna4478 = "c493e333-ed41-4b29-aef5-4949291faf3b";
          MrSnoffy = "e2448438-2665-4b75-b6f1-a636d5e73b3c";
          LanterneFar = "ae1b9823-55db-4101-9a94-5069753d11db";
          Criller0933 = "93761b36-0b7a-4f87-b605-98273f69063a";
          retbull = "23d75ce2-b89d-4512-bde2-9a0a38521fc0";
          Nexons2k = "52f367b7-e073-41f1-a2da-55c55678eee7";
          LolerSwager = "3801f32d-bfbc-4cd6-ac4a-7909f2318b08";
          _Jonathan = "397e0cbe-df20-411b-8296-b3b6560e4673";
          emil247k = "f28bdbed-91db-46a6-9a32-9f4cbf639926";
          Hovedpude = "04077843-0e2b-4796-ab40-52cf7f6a8c13";
          Mr16Dollars = "0eecb37c-d724-4854-8756-ec90fbca1e8e";
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
    };
    # declarative = true;
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
