{ lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/lib/alchemy-lab 0750 1000 1000 -"
  ];

  systemd.services = {
    alchemy-lab-config = {
      description = "Ensure Alchemy Lab server configuration has a section header";
      path = with pkgs; [
        coreutils
        gnugrep
      ];
      serviceConfig.Type = "oneshot";
      script = ''
        config=/var/lib/alchemy-lab/server/ServerConfig.ini
        install -d -m 0750 -o 1000 -g 1000 "$(dirname "$config")"

        if ! test -e "$config"; then
          printf '[ServerSettings]\n' > "$config"
        elif ! grep -Fxq '[ServerSettings]' "$config"; then
          temporary="$(mktemp --tmpdir="$(dirname "$config")" .ServerConfig.ini.XXXXXX)"
          {
            printf '[ServerSettings]\n'
            cat "$config"
          } > "$temporary"
          mv "$temporary" "$config"
        fi

        chown 1000:1000 "$config"
        chmod 0640 "$config"
      '';
    };

    docker-alchemy-lab = {
      requires = [ "alchemy-lab-config.service" ];
      after = [ "alchemy-lab-config.service" ];
      serviceConfig = {
        Restart = lib.mkForce "always";
        RestartSec = "1min";
        RestartSteps = 3;
        RestartMaxDelaySec = "1h";
      };
    };
  };

  networking.firewall.allowedUDPPorts = [
    9877
    9878
  ];

  virtualisation = {
    docker = {
      enable = true;
    };

    oci-containers = {
      backend = "docker";
      containers = {
        alchemy-lab = {
          image = "idarlafish/alchemy-factory-server:latest";
          autoStart = true;
          environment = {
            SERVER_NAME = "Alchemy Lab";
            # SERVER_RELAY = "1";
            SERVER_RELAY = "0";
            SERVER_PASSWORD = "det ved jeg ikke";
            ADMIN_PASSWORD = "duerikkeadmin";
            SERVER_PUBLIC = "0";
            TZ = "Europe/Copenhagen";
          };
          volumes = [
            "/var/lib/alchemy-lab:/data"
          ];
        };
      };
    };
  };
}
