let
  boat = import ./boat;
  enderman = import ./enderman;
in
{
  #inputs = boat.inputs;
  channels = inputs: boat.channels //
    (enderman.channels inputs);
  hosts = inputs@{ self, ... }: {
    boat = boat.host inputs;
    enderman = enderman.host inputs;
  };
}
