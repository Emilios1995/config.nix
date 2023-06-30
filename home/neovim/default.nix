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
      nvim-treesitter-textobjects
      nvim-lspconfig
    ];

    extraPackages = with pkgs; [
      lua-language-server
      nil #nix ls
      nodePackages.typescript-language-server
    ];

  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };

}
