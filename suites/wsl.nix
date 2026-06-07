{
  config,
  lib,
  pkgs,
  primaryUser,
  ...
}:
{
  environment.systemPackages = [
    pkgs.xdg-utils
    pkgs.keychain
  ];
  wsl = {
    enable = true;
    defaultUser = primaryUser;
    tarball.configPath = ../.;
    startMenuLaunchers = true;
  };
}
