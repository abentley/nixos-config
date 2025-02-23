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
      home.packages = [ vimPlugins.vim-jsonnet ];
      programs.bash.enable = true;
      home.stateVersion = "24.11";
      programs.neovim = neovim_config // {
        plugins = [ pkgs.vim-jsonnet ];
      };
    };
}
