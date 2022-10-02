let
  boat = import ./boat;
  end = import ./end;
  enderman = import ./enderman;
  steve = import ./steve;
  spider = import ./spider;
in
{
  #inputs = boat.inputs;
  hosts = inputs@{ self, ... }: {
    boat = boat.host inputs;
    end = end.host inputs;
    enderman = enderman.host inputs;
    steve = steve.host inputs;
    spider = spider.host inputs;
  };
  nodes = inputs: {
    end = end.node inputs;
    enderman = enderman.node inputs;
  };
}
