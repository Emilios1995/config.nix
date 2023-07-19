{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./neovim
    ./tmux.nix
  ];

  home.stateVersion = "23.11";

  programs.zsh.enable = true;
  programs.zsh.enableSyntaxHighlighting = true;
  programs.zsh.enableAutosuggestions = true;

  programs.zsh.shellAliases = {
    "atras" = "cd ..";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.starship = {
   enable =  true;
   enableZshIntegration = true;
   settings = {
    command_timeout = 1000;
   };
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
     -- Pull in the wezterm API
    local wezterm = require 'wezterm'

    local config = {}
    config = wezterm.config_builder()

    config.color_scheme = 'rose-pine'

    config.use_fancy_tab_bar = false
    config.tab_bar_at_bottom = true
    config.hide_tab_bar_if_only_one_tab = true

    config.use_cap_height_to_scale_fallback_fonts = true;
    config.font = wezterm.font "PragmataPro Mono Liga"
    config.line_height = 1.5
    -- config.allow_square_glyphs_to_overflow_width = "Never"
    config.font_size = 14.5

    return config
    '';
  };

  programs.bat = {
    enable = true;
    config.theme = "Solarized (dark)";
  };

  programs.fzf = 
    let fd = "${pkgs.fd}/bin/fd"; in
    rec {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "${fd} --type f";
      defaultOptions = [ "--height 50%" ];
      fileWidgetCommand = "${defaultCommand}";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --color=always --plain --line-range=:200 {}'"
      ];
      changeDirWidgetCommand = "${fd} --type d";
      changeDirWidgetOptions =
        [ "--preview '${pkgs.tree}/bin/tree -C {} | head -200'" ];
      historyWidgetOptions = [ ];
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };



  home.packages = with pkgs; [
    # installs gnu version of packages like ls, rm, etc.
    coreutils
    curl
    wget
    ripgrep
    jq
    fd
    ranger

    just
    postgresql_14
    (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.gke-gcloud-auth-plugin]))
    kubectl
    cloud-sql-proxy


    nodePackages.typescript
    nodePackages.pnpm
    nodejs
    yarn

    ghc
    hlint
    haskellPackages.cabal-install
    haskellPackages.hoogle
    haskellPackages.implicit-hie
    haskellPackages.cabal-fmt
    haskellPackages.cabal-plan
    haskellPackages.cabal-hoogle


    cargo

    comma
    manix
    nodePackages.node2nix
  ];
}
