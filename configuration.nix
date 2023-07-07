{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------


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

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") ["x86_64-darwin" "aarch64-darwin"];
  };

  nix.configureBuildUsers = true;

  programs.nix-index.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;

  # https://github.com/nix-community/home-manager/issues/423
  # environment.variables = {
  #  TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  # };

  users.users.emilio = {
    name = "emilio";
    description = "Emilio Srougo";
    home = "/Users/emilio";
  };

  environment.etc."rescript-vscode".source = "${pkgs.vscode-extensions.chenglou92.rescript-vscode}";
}
