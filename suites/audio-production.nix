{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ardour
    audacious
    audacious-plugins
    audacity
    flac # Provides metaflac
    jamulus
    loudgain
    python3Packages.mutagen
    qjackctl
    qsynth
    soundfont-fluid
    soundfont-generaluser
    sox
  ];
  services.pipewire.jack.enable = true;
}
