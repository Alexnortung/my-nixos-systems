{ self, ... }@args:

name: nixpkgs: system:
nixpkgs.lib.nixosSystem (
  let
    # configFolder = "${self}/systems";
    configFolder = "${self}/systems";
    entryPoint = "${configFolder}/${name}/configuration.nix";
  in
  {
    system = system;
    modules = [
      {
        _module.args = args;
        system.configurationRevision = self.rev or "dirty";
      }
      entryPoint
    ];
  }
)
