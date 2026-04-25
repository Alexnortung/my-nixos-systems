{
  lib,
  stdenv,
  fetchurl,
  cacert,
  curl,
  jq,
  git,
  ...
}:

let
  version = "0.7.1"; # Pinning to a specific version for reproducible fetches
  installScript = stdenv.mkDerivation {
    inherit version;
    pname = "openagentscontrol-install-script";

    src = fetchurl {
      url = "https://raw.githubusercontent.com/darrenhinde/OpenAgentsControl/v${version}/install.sh";
      # You will need to replace this with the actual sha256 of the install script
      # e.g., by running: nix-prefetch-url <url>
      hash = "sha256-KaLaC038InEx893Vxkm4lLV+5wRoQGtckqoZ57X33AI=";
    };

    unpackPhase = ''
      cp $src ./install.sh
      chmod +x ./install.sh
    '';
    patchPhase = ''
      substituteInPlace ./install.sh \
        --replace-fail \
          'BRANCH="''${OPENCODE_BRANCH:-main}"' \
          'BRANCH="v${version}"'
      patchShebangs ./install.sh
    '';
    installPhase = ''
      install -Dm755 ./install.sh $out/install.sh
    '';

  };
in

stdenv.mkDerivation {
  inherit version;
  pname = "openagentscontrol";

  nativeBuildInputs = [
    cacert
    curl
    jq
    git
  ];

  dontUnpack = true;

  buildPhase = ''
    # Setup the output directory structure inside the Nix store
    mkdir -p .config/opencode

    # We need a dummy HOME since the script might try to read/write to ~/.config or ~/.env
    export HOME=$(mktemp -d)

    # Run the patched installer.
    # We use the 'developer' profile here, but it can be swapped to 'core' or 'full'.
    # We pass --install-dir to force it to install into our Nix output path.
    bash ${installScript}/install.sh developer --install-dir .config/opencode
  '';

  installPhase = ''
    rm .config/opencode/README.md
    rm .config/opencode/env.example
    mkdir -p $out/.config
    cp -r .config/opencode $out/.config/opencode
    echo "Installation complete in $out/.config/opencode"
  '';

  # Because the install script invokes `curl` to download additional files dynamically,
  # this MUST be a Fixed-Output Derivation (FOD). This is the only way Nix allows
  # network access during the build phase.
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  # You will need to replace this with the actual output hash after your first build attempt. Nix will error out and tell you the correct "got: sha256-..." hash to put here.
  outputHash = "sha256-H1tUjmwMHL4po0ebzvWcSH0jPrJnaE6RJm+L44NeNgc=";

  meta = with lib; {
    description = "AI agent framework for plan-first development workflows";
    homepage = "https://github.com/darrenhinde/OpenAgentsControl";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
