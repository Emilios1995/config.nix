{ config, lib, pkgs, ... }:

let
  brewBinPrefix = if pkgs.system == "aarch64-darwin" then "/opt/homebrew/bin" else "/usr/local/bin";
in

{
  programs.zsh.shellInit = ''
    eval "$(${brewBinPrefix}/brew shellenv)"
  '';

  homebrew.enable = true;
  homebrew.brewPrefix = brewBinPrefix;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.brews = [
    "watchman"
    "kubefwd"
    "opam"
  ];

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
    "txn2/tap"
  ];

  # If an app isn't available in the Mac App Store install the Homebrew Cask.
  homebrew.casks = [
    "tuple"
    "zoom"
    "discord"
    "raycast"
    "arc"
    "postico"
    "insomnia"
    "slack"
    "1password"
    "notion"
    "whatsapp-beta"
    "loom"
    "tidal"
    "google-chrome"
  ];
}
