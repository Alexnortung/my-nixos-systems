let
  boat = import ./boat;
  chest = import ./chest;
  end = import ./end;
  enderman = import ./enderman;
  paper = import ./paper;
  spider = import ./spider;
  steve = import ./steve;
in
{
  #inputs = boat.inputs;
  hosts =
    inputs@{ self, ... }:
    {
      boat = boat.host inputs;
      # chest = chest.host inputs;
      end = end.host inputs;
      enderman = enderman.host inputs;
      paper = paper.host inputs;
      spider = spider.host inputs;
      steve = steve.host inputs;
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
