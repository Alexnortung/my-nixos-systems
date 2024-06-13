let
  boat = import ./boat;
  chest = import ./chest;
  end = import ./end;
  enderman = import ./enderman;
  steve = import ./steve;
  spider = import ./spider;
in
{
  #inputs = boat.inputs;
  hosts = inputs@{ self, ... }: {
    boat = boat.host inputs;
    # chest = chest.host inputs;
    end = end.host inputs;
    enderman = enderman.host inputs;
    steve = steve.host inputs;
    spider = spider.host inputs;
  };
  nodes = inputs: {
    # chest = chest.node inputs;
    end = end.node inputs;
    enderman = enderman.node inputs;
  };
  cachixDeployAgents = inputs: {
    chest = chest.cachixDeployAgent inputs;
  };
}
