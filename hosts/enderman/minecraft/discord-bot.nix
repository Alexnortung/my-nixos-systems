{ pkgs
, config
, inputs
, ...
}:

let
  system = "x86_64-linux";
in
{
  imports = [
    # inputs.block-busters.nixosModules.discord-bot
  ];

  services.block-busters-discord-bot = {
    enable = true;
    package = inputs.block-busters.packages.${system}.discord-bot;

    rconHost = "127.0.0.1";
    rconPort = 25575;

    environmentFile = config.age.secrets.minecraft-discord-bot-env.path;
  };
}
