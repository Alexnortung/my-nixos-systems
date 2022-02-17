let
  boat = import ./boat;
in
{
  inputs = boat.inputs;
  channels = boat.channels;
  hosts = inputs@{ self, ... }: {
    boat = boat.host inputs;
  };
}
