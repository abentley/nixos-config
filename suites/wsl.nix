{
  config,
  lib,
  pkgs,
  primaryUser,
  ...
}:
{
  environment.systemPackages = [
    pkgs.wslu
    pkgs.xdg-utils
    pkgs.keychain
  ];
  # Make life easier in the absence of gnome-keychain
  programs.ssh.extraConfig = "AddKeysToAgent yes";
  programs.bash.interactiveShellInit = ''eval "$(keychain --eval --quiet)"'';

  wsl = {
    enable = true;
    defaultUser = primaryUser;
    tarball.configPath = ../.;
    startMenuLaunchers = true;
  };
}
