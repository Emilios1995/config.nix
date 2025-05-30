{ pkgs, lib, inputs', ...}:
with lib;
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      set runtimepath+=~/.config/nix/home/neovim/config
      lua require 'emilios.init'
    '';

    plugins = 
    let p = pkgs.vimPlugins; e = pkgs.vimExtraPlugins; in [
       e.mini-nvim  
       e.rose-pine
       {
         plugin = (p.nvim-treesitter.withPlugins (_: (
           [ pkgs.tree-sitter-grammars.tree-sitter-rescript ]
           ++ [ pkgs.tree-sitter-grammars.tree-sitter-tailwind ]
           ++ p.nvim-treesitter.allGrammars)
           ));
       }
       e.nvim-treesitter-textobjects
       e.nvim-lspconfig
       e.trouble-nvim
       e.oil-nvim
       e.telescope-nvim
       p.telescope-fzf-native-nvim
       p.telescope-live-grep-args-nvim
       p.tree-sitter-rescript
       p.Navigator-nvim # navigate between nvim and tmux
       e.copilot-lua
       #e.copilot-vim
       p.gitlinker-nvim
       e.diffview-nvim
       e.nvim-cmp
       e.cmp-nvim-lsp
       e.cmp-buffer
       e.cmp-path
       e.cmp-luasnip
       e.cmp-cmdline
       e.LuaSnip
       e.gitsigns-nvim
       p.neogit
       e.zen-mode-nvim
       p.sg-nvim
       e.no-neck-pain-nvim
       e.grapple-nvim
       p.bufjump-nvim
       e.noice-nvim
       #e.nvim-notify
       e.nui-nvim
       p.typescript-tools-nvim
       e.gen-nvim
       p.telescope-ui-select-nvim
       e.telescope-luasnip-nvim
       e.nvim-lint
       e.conform-nvim
       p.nvim-web-devicons
       e.catppuccin
       e.aerial-nvim
    ];

    extraPackages = 
    [pkgs.pkgs-23-11.lua-language-server] ++
    (with pkgs; [
      nil #nix ls
      nodePackages.typescript-language-server
      nodePackages."@tailwindcss/language-server"
      #nodePackages.graphql-language-service-cli
      #nodePackages.pyright
      sg-nvim
    ]);

  };

}
