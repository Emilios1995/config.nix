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
       e.mini-nvim-nvim-mini
       e.rose-pine-rose-pine
       {
         plugin = (p.nvim-treesitter.withPlugins (_: (
           # [ pkgs.tree-sitter-grammars.tree-sitter-rescript ]
            [ pkgs.tree-sitter-grammars.tree-sitter-tailwind ]
           ++ p.nvim-treesitter.allGrammars)
           ));
       }
       e.nvim-treesitter-textobjects-nvim-treesitter
       e.nvim-lspconfig-neovim
       e.trouble-nvim-folke
       e.oil-nvim-stevearc
       e.telescope-nvim-nvim-telescope
       p.telescope-fzf-native-nvim
       p.telescope-live-grep-args-nvim
       # p.tree-sitter-rescript
       p.Navigator-nvim # navigate between nvim and tmux
       e.copilot-lua-zbirenbaum
       #e.copilot-vim
       p.gitlinker-nvim
       e.diffview-nvim-sindrets
       e.nvim-cmp-hrsh7th
       e.cmp-nvim-lsp-hrsh7th
       e.cmp-buffer-hrsh7th
       e.cmp-path-hrsh7th
       e.cmp-luasnip-saadparwaiz1
       e.cmp-cmdline-hrsh7th
       e.LuaSnip-L3MON4D3
       e.gitsigns-nvim-lewis6991
       p.neogit
       e.zen-mode-nvim-folke
       p.sg-nvim
       e.no-neck-pain-nvim-shortcuts
       e.grapple-nvim-cbochs
       p.bufjump-nvim
       e.noice-nvim-folke
       #e.nvim-notify
       e.nui-nvim-MunifTanjim
       p.typescript-tools-nvim
       e.gen-nvim-David-Kunz
       p.telescope-ui-select-nvim
       e.telescope-luasnip-nvim-benfowler
       e.nvim-lint-mfussenegger
       e.conform-nvim-stevearc
       p.nvim-web-devicons
       e.catppuccin-catppuccin
       e.aerial-nvim-stevearc
       e.orgmode-nvim-orgmode
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
