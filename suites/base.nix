# Provide a base suite of console-based packages and configurations for all
# systems.
{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    command-not-found.enable = true;
    git.enable = true;
    mtr.enable = true;
    # Install neovim
    neovim = {
      enable = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
      viAlias = true;
    };
    tmux.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    atop
    autoconf
    automake
    breezy
    btop
    colordiff
    dive
    ffmpeg
    file
    gcc
    gccStdenv
    graphviz
    htop
    iftop
    iperf3
    just
    jsonnet
    keychain
    libtool
    lsof
    macchina
    ncdu
    nethogs
    nixfmt
    nixfmt-tree
    nix-diff
    nix-search
    nmap
    ntfs3g
    openssl_3
    opentofu
    pciutils
    pigz
    pkg-config
    pv
    python3
    python3Packages.autopep8
    python3Packages.flake8
    python3Packages.pygments
    ripgrep
    squashfsTools
    stdenv
    sysdig
    tree
    usbutils
    uv
    wavemon
    wget
    whois
  ];

  environment.variables = {
    # EDITOR already set by programs.neovim.defaultEditor = true;
    # EDITOR = "nvim";
  };
  environment.homeBinInPath = true;

  # Provide an alternative to gnome-keychain if not running.
  programs.ssh.startAgent = lib.mkDefault true;
  programs.ssh.extraConfig = "AddKeysToAgent yes";
  programs.bash.interactiveShellInit = ''
    # If the login session hasn't given us an agent, check our standard system
    # paths top-down
    if [ -z "$SSH_AUTH_SOCK" ]; then
      if [ -S "/run/user/$UID/gcr/ssh" ]; then
        export SSH_AUTH_SOCK="/run/user/$UID/gcr/ssh"
      elif [ -S "/run/user/$UID/ssh-agent" ]; then
        export SSH_AUTH_SOCK="/run/user/$UID/ssh-agent"
      fi
    fi
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.locate.enable = true;
  virtualisation.containers.enable = true;
}
