{ pkgs, lib, ...}:
with lib;
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      :luafile ~/.config/nix/home/neovim/config/init.lua
    '';

  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
