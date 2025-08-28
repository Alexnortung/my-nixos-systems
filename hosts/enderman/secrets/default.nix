{
  imports = [
    ../../../config/secrets
  ];

  age.secrets = {
    cross-seed-config.file = ./cross-seed.json.age;
    minecraft-discord-bot-env.file = ./minecraft-discord-bot-env.age;
    mealie-credentials.file = ./mealie-credentials.age;
  };
}
