{
  overlays = channels: [
    (import ./pre-master/emojipick.nix channels.emojipick)
    (import ./pre-master/spicetify.nix channels.spicetified-spotify)
  ];
}
