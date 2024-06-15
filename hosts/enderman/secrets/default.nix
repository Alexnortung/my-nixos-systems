{
  imports = [
    ../../../config/secrets
  ];

  age.secrets = {
    minecraft-discord-bot-env.file = ./minecraft-discord-bot-env.age;
  };
}
