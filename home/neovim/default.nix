{ pkgs, lib, inputs', ...}:
with lib;
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      :luafile ~/.config/nix/home/neovim/config/init.lua
    '';

    plugins = 
    let p = pkgs.vimPlugins; e = pkgs.vimExtraPlugins; in [
       e.mini-nvim  
       e.rose-pine
       {
         plugin = (p.nvim-treesitter.withPlugins (_: (
           [ pkgs.tree-sitter-grammars.tree-sitter-rescript ]
           ++ p.nvim-treesitter.allGrammars)
           ));
       }
       e.nvim-treesitter-textobjects
       e.nvim-lspconfig
       e.null-ls-nvim
       e.trouble-nvim
       e.oil-nvim
       e.telescope-nvim
       p.telescope-fzf-native-nvim
       p.telescope-live-grep-args-nvim
       p.nvim-treesitter-rescript
       p.Navigator-nvim # navigate between nvim and tmux
       e.copilot-lua
       p.gitlinker-nvim
       p.fidget-legacy-nvim
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
    ];

    extraPackages = 
    [pkgs.pkgs-stable.lua-language-server] ++
    (with pkgs; [
      nil #nix ls
      nodePackages.typescript-language-server
      nodePackages."@tailwindcss/language-server"
      nodePackages.graphql-language-service-cli
      sg-nvim
    ]);

  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
