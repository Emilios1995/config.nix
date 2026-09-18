{ ... }:

{
  programs.ssh = {
    enable = true;

    # Home-manager's legacy `Host *` defaults; setting this false silences the
    # deprecation warning and leaves stock OpenSSH defaults in place.
    enableDefaultConfig = false;

    # This line was the entire hand-written ~/.ssh/config before home-manager took
    # ownership of the file. HM emits Include first, ahead of all match blocks.
    includes = [ "/Users/emilio/.colima/ssh_config" ];

    settings.desk = {
      # Personal-tailnet MagicDNS name. NOT the work tailnet, which resolves this
      # same machine as emilios-mac-studio.tailb3be00.ts.net.
      HostName = "emilios-mac-studio.tail6bc754.ts.net";
      User = "emilio";
      # Survive lid closes and network switches instead of hanging dead.
      ServerAliveInterval = 30;
      ServerAliveCountMax = 6;
    };
  };

  # mosh reuses the `desk` block above for its ssh handshake, then talks UDP
  # directly. That UDP survives lid closes and network changes, which plain ssh
  # does not.
  #
  # --server needs an absolute path: mosh starts mosh-server over a
  # non-interactive ssh shell, whose PATH does not include the Nix profile. This
  # symlink is stable across rebuilds; a /nix/store path would not be.
  programs.zsh.shellAliases = {
    desk = "mosh --server=/etc/profiles/per-user/emilio/bin/mosh-server desk -- tmux new -A -s main";
    sshdesk = "ssh -t desk 'tmux new -A -s main'";
  };
}
