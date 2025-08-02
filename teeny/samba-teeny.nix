{ ... }:
import ../features/samba.nix {
  name = "teeny";
  shares = {
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
}
