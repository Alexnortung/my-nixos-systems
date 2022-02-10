{ self, ... }@inputs:

{
  boat = self.lib.mkSystem "boat" inputs.nixpkgs-boat "x86_64-linux";
  #enderman = self.lib.mkSystem "enderman" inputs.nixpkgs-enderman "x86_64-linux";
  #spider = self.lib.mkSystem "spider" inputs.nixpkgs-spider "x86_64-linux";
  #steve = self.lib.mkSystem "steve" inputs.nixpkgs-steve "x86_64-linux";
}
