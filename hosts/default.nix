let
  boat = import ./boat;
  enderman = import ./enderman;
  steve = import ./steve;
  spider = import ./spider;
in
{
  #inputs = boat.inputs;
  channels = inputs: (boat.channels inputs) //
    (enderman.channels inputs) //
    (spider.channels inputs) //
    (steve.channels inputs);
  hosts = inputs@{ self, ... }: {
    boat = boat.host inputs;
    enderman = enderman.host inputs;
    steve = steve.host inputs;
    spider = spider.host inputs;
  };
  nodes = inputs: {
    enderman = enderman.node inputs;
  };
}
