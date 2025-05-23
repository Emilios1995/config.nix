{ pkgs, lib, ... }:
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

    experimental-features=  [
      "ca-derivations"
      "nix-command"
      "flakes"
    ];

    keep-derivations = true;
    keep-outputs = true;

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") ["x86_64-darwin" "aarch64-darwin"];
  };


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
  };

  age.identityPaths = ["/Users/emilio/.ssh/id_ed25519"];
}
