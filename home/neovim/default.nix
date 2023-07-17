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
      {
        plugin = (nvim-treesitter.withPlugins (p: (
          [ pkgs.tree-sitter-grammars.tree-sitter-rescript ]
          ++ nvim-treesitter.allGrammars)
          ));
      }
      nvim-treesitter-textobjects
      nvim-lspconfig
      null-ls-nvim
      trouble-nvim
      oil-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-live-grep-args-nvim
      nvim-treesitter-rescript
      Navigator-nvim
    ];

    extraPackages = with pkgs; [
      lua-language-server
      nil #nix ls
      nodePackages.typescript-language-server
      nodePackages."@tailwindcss/language-server"
    ];

  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };

}
