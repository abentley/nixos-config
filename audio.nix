{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qsynth
    qjackctl
    audacity
    ardour
  ];
  services.pipewire.jack.enable = true;
}
