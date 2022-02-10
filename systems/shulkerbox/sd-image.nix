{ ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];
  # put your own configuration here, for example ssh keys:
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [
    /home/alexander/.ssh/id_rsa.pub
  ];

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    openFirewall = true;
    permitRootLogin = "without-password";
    passwordAuthentication = false;
  };
}
