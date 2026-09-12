{
  systemd.tmpfiles.rules = [
    "d /var/lib/alchemy-lab 0750 1000 1000 -"
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
          environment = {
            SERVER_NAME = "Alchemy Lab";
            SERVER_RELAY = "1";
            SERVER_PASSWORD = "det ved jeg ikke";
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
