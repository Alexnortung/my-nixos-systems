# This overlay should be used as the first overlay for every system
# it works by importing it and giving it the unstable channel for
# that system.
# Then the overlay makes sure the following programs follow unstable
unstable-channel: final: prev: {
  inherit (unstable-channel) steam
    superTuxKart
    discord
    session-desktop
    xmrig
    torbrowser
    minecraft
    nordzy-cursor-theme
    sagetex
    mullvad-vpn
    # libreoffice
    blender
    dbeaver
    beekeeper-studio
    futhark
    ;
}
