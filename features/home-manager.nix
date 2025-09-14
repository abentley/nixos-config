# Provide Home Manager as a feature.
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.abentley = ../users/abentley.nix;
    users.root = ../users/root.nix;
    backupFileExtension = "backup";
  };
}
