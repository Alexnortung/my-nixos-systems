# This overlay should be used as the first overlay for every system
# it works by importing it and giving it the unstable channel for
# that system.
# Then the overlay makes sure the following programs follow unstable
unstable-channel: final: prev: {
  inherit (unstable-channel) steam
    discord
    tdesktop
    session-desktop-appimage
    ungoogled-chromium
    firefox
    xmrig
    torbrowser
    minecraft
    clang-tools
    rust-analyzer
    nordzy-cursor-theme
    sagetex
    mullvad-vpn
    libreoffice
    blender
    dbeaver
    beekeeper-studio
    futhark
    ;
}
