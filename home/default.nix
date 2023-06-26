{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./neovim
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

  /*
  programs.wezterm = {
    enable = true;
  };
  */

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
