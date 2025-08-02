{ pkgs, old-nixpkgs, primaryUser, ... }:
let
  pkgs = import old-nixpkgs {system = "x86_64-linux";};
  comskip = (pkgs.callPackage ../packages/comskip.nix {pkgs = pkgs; });
in
{
  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;
  environment.systemPackages = [
    # pkgs.jellyfin
    # pkgs.jellyfin-web
    # pkgs.jellyfin-ffmpeg
    # Provide CLI hdhomerun_config
    pkgs.libhdhomerun
    pkgs.hdhomerun-config-gui
    # Support hdhomerun-config-gui View button
    pkgs.vlc
    # Support commercial cutting
    comskip
  ];
  users.users.${primaryUser}.extraGroups = [ "jellyfin" ];
  # HDHomerun's discovery mechanism requires me to receive packets to an
  # arbitrary port with a source-port of 65001
  networking.firewall.extraInputRules = "udp sport 65001 accept";
}
