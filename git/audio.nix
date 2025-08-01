{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    audacious
    audacious-plugins
    qsynth
    qjackctl
    audacity
    ardour
    soundfont-generaluser
    soundfont-fluid
    jamulus
  ];
  services.pipewire.jack.enable = true;
}
