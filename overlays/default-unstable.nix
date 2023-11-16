# This overlay should be used as the first overlay for every system
# it works by importing it and giving it the unstable channel for
# that system.
# Then the overlay makes sure the following programs follow unstable
unstable-channel: final: prev: {
  inherit (unstable-channel) steam
    superTuxKart
    webcord
    discord
    session-desktop
    session-desktop-appimage
    xmrig
    torbrowser
    minecraft
    nordzy-cursor-theme
    sagetex
    # mullvad
    # mullvad-vpn
    # libreoffice
    blender
    dbeaver
    beekeeper-studio
    futhark
    ;
}
