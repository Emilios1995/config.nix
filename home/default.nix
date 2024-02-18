{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./neovim
    ./tmux.nix
  ];

  home.stateVersion = "23.11";

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    initExtra = ''
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
    '';
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
    package = if pkgs.stdenv.hostPlatform.isAarch64 then pkgs.wezterm else pkgs.pkgs-23-05.wezterm;
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

    -- config.use_cap_height_to_scale_fallback_fonts = true;
    config.font = wezterm.font "PragmataPro Mono Liga"
    config.line_height = 1.5
    config.font_size = 14.5

    config.background = {
      {
        source = {
          File = "Users/emilio/backgrounds/gravity.jpeg",
        },
        width = '100%',
      },
      {
        source = {
          Color = "#191724",
        },
        width = '100%',
        height = '100%',
        opacity = 0.90
      }
    }

    wezterm.on('toggle-background', function(window, pane)
      local overrides = window:get_config_overrides() or {}
      if not overrides.background then
        overrides.background = {}
      else
        overrides.background = nil
      end
      window:set_config_overrides(overrides)
    end)

    config.keys = {
      {
        key = 'I',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'toggle-background',
      },
    }

    return config
    '';
  };

  programs.bat = {
    enable = true;
    config.theme = "Solarized (Dark)";
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

  programs.java.enable = true;

  home.packages = with pkgs; [
    # installs gnu version of packages like ls, rm, etc.
    coreutils
    curl
    wget
    ripgrep
    jq
    fd
    ranger
    zsh-forgit

    just
    postgresql_14
    (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.gke-gcloud-auth-plugin google-cloud-sdk.components.pubsub-emulator ]))
    kubectl
    google-cloud-sql-proxy
    graphite-cli

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
    #pkgs-23-05.haskellPackages.cabal-plan
    #pkgs-23-05.haskellPackages.cabal-hoogle

    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat_0_23_0


    cargo

    comma
    manix
    nodePackages.node2nix

    nix-output-monitor

   # ollama: commented since the available version is out of date
    bun
  ];

  home.file.backgrounds.source = ../backgrounds;
}
