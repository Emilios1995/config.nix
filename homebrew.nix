{ config, lib, pkgs, ... }:

let
  brewPrefix = if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then "/opt/homebrew" else "/usr/local";
in

{
  programs.zsh.shellInit = ''
    eval "$(${brewPrefix}/bin/brew shellenv)"
  '';

  homebrew.enable = true;
  homebrew.prefix = brewPrefix;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.onActivation.cleanup = "zap";

  # Homebrew 6 requires third-party formulae to be trusted before `brew bundle`
  # can inspect or install them. Run this immediately before nix-darwin's
  # Homebrew activation so rebuilds do not depend on mutable trust state.
  system.activationScripts.homebrew.text = lib.mkBefore ''
    if sudo --user=${lib.escapeShellArg config.homebrew.user} --set-home \
      ${brewPrefix}/bin/brew command trust >/dev/null 2>&1; then
      sudo --user=${lib.escapeShellArg config.homebrew.user} --set-home \
        ${brewPrefix}/bin/brew trust --formula \
          txn2/tap/kubefwd \
          withgraphite/tap/graphite
    fi
  '';

  homebrew.brews = [
    "watchman"
    "txn2/tap/kubefwd"
    "graphite"
    "gmp"
    "pkgconf"
    "dbus"
    "icu4c@77"
    "zstd"
    # "openclaw/tap/wacli"
  ];

  homebrew.taps = [
    "homebrew/cask-versions"
    "homebrew/services"
    "txn2/tap"
    "withgraphite/tap"
    # "openclaw/tap"
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
    "whatsapp"
    "loom"
    "tidal"
    "google-chrome"
    #"google-chrome-canary"
    "firefox"
    "calibre"
    #"chatgpt"
    "miniconda"
    "macfuse"
  ];
}
