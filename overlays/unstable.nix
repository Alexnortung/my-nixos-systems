inputs: system: final: prev: {
  unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
}
