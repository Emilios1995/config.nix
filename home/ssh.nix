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

    matchBlocks.desk = {
      # Personal-tailnet MagicDNS name. NOT the work tailnet, which resolves this
      # same machine as emilios-mac-studio.tailb3be00.ts.net.
      hostname = "emilios-mac-studio.tail6bc754.ts.net";
      user = "emilio";
      # Survive lid closes and network switches instead of hanging dead.
      serverAliveInterval = 30;
      serverAliveCountMax = 6;
    };
  };

  programs.zsh.shellAliases.desk = "ssh -t desk 'tmux new -A -s main'";
}
