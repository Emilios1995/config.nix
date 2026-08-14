# A second Tailscale daemon, for the *personal* tailnet, running alongside the work
# Tailscale.app.
#
# Tailscale.app (the `macsys` build in /Applications) keeps owning the real utun
# interface and the 100.64.0.0/10 routes for the work tailnet. This adds a second
# `tailscaled` in userspace-networking mode: no interface, no routes, so the two
# daemons cannot fight over the CGNAT range.
#
# Inbound connections to this node's personal-tailnet IP are proxied by tailscaled to
# 127.0.0.1 on the same port, which is what makes `ssh` from the laptop reach sshd.
#
# One-time login after the first `just switch` (state then persists in stateDir):
#
#   tsp up --hostname=emilios-mac-studio --accept-dns=false --accept-routes=false
#
# --accept-dns=false matters: without it tailscaled tries to take over system DNS and
# would fight the work daemon. Then disable key expiry for the node in the personal
# admin console so you never have to re-auth.
{ config, lib, pkgs, ... }:

let
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;

  stateDir = "${home}/.local/state/tailscale-personal";
  socket = "${stateDir}/tailscaled.sock";
  logFile = "${home}/Library/Logs/tailscale-personal.log";

  # nixpkgs ships one multi-call binary; argv[0] selects daemon vs CLI, and the
  # makeWrapper stub preserves it via `exec -a "$0"`.
  tailscaled = lib.getExe' pkgs.tailscale "tailscaled";
  tailscaleCli = lib.getExe' pkgs.tailscale "tailscale";

  # Deliberately NOT installed as `tailscale`: /run/current-system/sw/bin comes before
  # /usr/local/bin on PATH, so a `tailscale` here would shadow the shim Tailscale.app
  # installs and break work-tailnet CLI use. `tsp` = personal, `tailscale` = work.
  tsp = pkgs.writeShellScriptBin "tsp" ''
    exec ${tailscaleCli} --socket=${socket} "$@"
  '';
in
{
  environment.systemPackages = [ tsp ];

  launchd.user.agents.tailscale-personal = {
    script = ''
      /bin/mkdir -p ${lib.escapeShellArg stateDir}
      /bin/chmod 700 ${lib.escapeShellArg stateDir}
      exec ${tailscaled} \
        --tun=userspace-networking \
        --socks5-server=127.0.0.1:1055 \
        --port=41642 \
        --statedir=${lib.escapeShellArg stateDir} \
        --socket=${lib.escapeShellArg socket}
    '';
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = logFile;
      StandardErrorPath = logFile;
    };
  };

  # Inbound SSH is the whole point. nix-darwin bootstraps com.openssh.sshd directly,
  # which — unlike `systemsetup -setremotelogin` — needs no Full Disk Access.
  services.openssh.enable = true;

  # `pmset -g custom` showed `sleep 1`: the box would nap out from under a live tmux
  # session. Display sleep is left alone (already never).
  power.sleep.computer = "never";
  power.sleep.harddisk = "never";
}
