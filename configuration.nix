{ pkgs, lib, config, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------
  imports = [
    ./homebrew.nix
  ];

  nix.settings = {
    binary-caches = [
      "https://cache.nixos.org/"
    ];

    binary-cache-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trusted-users = [
      "@admin"
      "emilio"
    ];

    experimental-features = [
      "ca-derivations"
      "nix-command"
      "flakes"
    ];

    keep-derivations = true;
    keep-outputs = true;

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  # The included file (decrypted by agenix) contains:
  #   access-tokens = github.com=ghp_...
  # `!include` is optional, so a rebuild before the secret is decrypted won't fail.
  nix.extraOptions = ''
    !include ${config.age.secrets.github-token.path}
  '';

  programs.nix-index.enable = true;

  nix.enable = true;

  programs.zsh.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };

  users.users.emilio = {
    name = "emilio";
    description = "Emilio Srougo";
    home = "/Users/emilio";
  };

  system.primaryUser = "emilio";

  environment.etc."rescript-vscode".source = "${pkgs.vscode-marketplace.chenglou92.rescript-vscode}";

  system.stateVersion = 5;

  ids.gids.nixbld = 30000;

  age.secrets = {
    test = {
      file = ./secrets/test.age;
      path = "/Users/emilio/agenix-test";
      mode = "700";
      owner = "emilio";
    };
    "aider.env" = {
      file = ./secrets/aider.env.age;
      path = "/Users/emilio/.aider.env";
      mode = "700";
      owner = "emilio";
    };
    pgpass = {
      file = ./secrets/pgpass.age;
      path = "/Users/emilio/.pgpass";
      mode = "600";
      owner = "emilio";
    };
    cachix-authtoken = {
      file = ./secrets/cachix-authtoken.dhall.age;
      mode = "700";
      owner = "emilio";
    };
    nix-netrc = {
      file = ./secrets/nix-netrc.age;
      mode = "700";
      owner = "emilio";
    };
    github-token = {
      file = ./secrets/github-token.age;
      # Readable by the user: flake inputs are fetched during evaluation by the
      # user's `nix` process, not the root daemon, so `!include`-ing this into
      # nix.conf only helps if the user can read it. Without this the private
      # topagentnetwork/* github: inputs fail to auth and GitHub 404s them.
      mode = "600";
      owner = "emilio";
    };
  };

  age.identityPaths = [ "/Users/emilio/.ssh/id_ed25519" ];
}
