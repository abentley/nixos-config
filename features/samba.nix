# Provide Samba as a feature.
{ name, shares, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "security" = "user";
        "server string" = name;
        "netbios name" = name;
        # Activating causes "invalid argument" accessing names with
        # double-quotes.
        # "mangled names" = "no";
        "dos charset" = "CP850";
        "unix charset" = "UTF-8";
        # This was claimed to fix quoted names, but no.
        # "unix extensions" = "no";

        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.91. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
    }
    // shares;
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
}
