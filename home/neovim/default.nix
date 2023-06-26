{ pkgs, lib, ...}:
with lib;
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      :luafile ~/.config/nix/home/neovim/config/init.lua
    '';

    plugins = with pkgs.vimPlugins; [
      mini-nvim  
      rose-pine
      nvim-treesitter.withAllGrammars
    ];

  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
