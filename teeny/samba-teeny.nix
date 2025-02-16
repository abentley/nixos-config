{ config, pkgs, ... }:
{
imports = [../samba.nix];
services.samba = {
  settings = {
    global = {
      "server string" = "teeny";
      "netbios name" = "teeny";
      #"use sendfile" = "yes";
      #"max protocol" = "smb2";
      # note: localhost is the ipv6 localhost ::1
    };
    "music" = {
      "path" = "/mnt/bcachefs/Music";
      "browseable" = "yes";
      "read only" = "yes";
      "guest ok" = "yes";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "jellyfin";
      "force group" = "jellyfin";
    };
  };
};
}
