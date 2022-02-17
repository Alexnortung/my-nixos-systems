{
  inputs = {

  };
  overlays = channels: [
    (import ./pre-master/emojipick.nix channels.emojipick)
  ];
}
