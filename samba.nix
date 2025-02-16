{ config, pkgs, ... }:
{
services.samba = {
  enable = true;
  openFirewall = true;
  settings = {
    global = {
      "workgroup" = "WORKGROUP";
      "security" = "user";
      #"use sendfile" = "yes";
      #"max protocol" = "smb2";
      # note: localhost is the ipv6 localhost ::1
      "hosts allow" = "192.168.91. 127.0.0.1 localhost";
      "hosts deny" = "0.0.0.0/0";
      "guest account" = "nobody";
      "map to guest" = "bad user";
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
    "vr" = {
      "path" = "/mnt/bcachefs/.shrimpy/anim/VR";
      "browseable" = "yes";
      "read only" = "yes";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "abentley";
      "force group" = "jellyfin";
    };
  };
};

services.samba-wsdd = {
  enable = true;
  openFirewall = true;
};

networking.firewall.enable = true;
networking.firewall.allowPing = true;
}
