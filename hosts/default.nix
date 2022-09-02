let
  boat = import ./boat;
  enderman = import ./enderman;
  steve = import ./steve;
  spider = import ./spider;
in
{
  #inputs = boat.inputs;
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
