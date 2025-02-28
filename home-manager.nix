{ config, pkgs, ... }:
let
  neovim_config = {
    enable = true;
    extraConfig = ''
      colorscheme murphy
      set shiftwidth=4
      set expandtab
      se tabstop=4
      se smarttab
      se hlsearch
      se visualbell
      se list
      se listchars=tab:>.,trail:-
    '';
# call plug#begin()
# Plug 'google/vim-jsonnet'
# call plug#end()
  };
in
{
  imports = [ <home-manager/nixos> ];

  home-manager.users.root =
    { pkgs, ... }:
    {
      home.stateVersion = "24.11";
      programs.bash.enable = true;
      programs.neovim = neovim_config;
    };
  home-manager.users.abentley =
    { pkgs, ... }:
    {
      home.packages = [ ];
      programs.bash.enable = true;
      home.stateVersion = "24.11";
      programs.neovim = neovim_config // {
#        plugins = [ vimPlugins.vim-jsonnet ];
      };
      home.file.".config/halloy/config.toml".text = ''
        [servers.liberachat]
        nickname = "abentley"
        server = "irc.libera.chat"
        channels = ["#halloy"]
      '';
      home.file.".config/hypr/shared.conf".source = ./hyprland-shared.conf;
      home.file.".config/waybar/config.jsonc".source = ./waybar-config.jsonc;
      home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
    };
}
