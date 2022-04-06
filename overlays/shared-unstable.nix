channel:
final: prev: {
  inherit (channel)
    vimPlugins
    vscode-extensions
    nodePackages # take all node packages from unstable by default.
    ;
}
