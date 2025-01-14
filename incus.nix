{ config, pkgs, ... }:
{
  networking.firewall.trustedInterfaces = [ "incusbr0" ];

  # Needed for Incus
  networking.nftables.enable = true;

  users.users.abentley = {
    extraGroups = [ "incus-admin" ];
  };

  # Too special to install as a package
  virtualisation.incus.enable = true;

  # ?
  virtualisation.incus.ui.enable = true;
}
