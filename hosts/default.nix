let
  boat = import ./boat;
in
{
  inputs = boat.inputs;
  hosts = inputs@{ self, ... }: {
    boat = boat.host;
  };
}
