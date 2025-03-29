{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qsynth
    qjackctl
    audacity
    ardour
    soundfont-generaluser
    soundfont-fluid
  ];
  services.pipewire.jack.enable = true;
}
