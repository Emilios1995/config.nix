{pkgs, lib, ...}: 

{
  programs.tmux = {
    prefix = "C-a";
    enable = true;
    clock24 = true;
    keyMode = "vi";
    mouse = true;

     plugins = with pkgs.tmuxPlugins; [
       sensible
       vim-tmux-navigator
       pain-control
       t-smart-tmux-session-manager
       catppuccin
     ];

     extraConfig = ''
       set -as terminal-features ",xterm-256color:RGB"
       set -g @catppuccin_flavour 'latte'
       bind -T copy-mode-vi 'v' send -X begin-selection
       bind -T copy-mode-vi 'y' send -X copy-selection-and-cancel
       bind-key G new-window -n lazygit -c "#{pane_current_path}" direnv exec . lazygit
       bind-key A switch-client -l
       set -g default-command '$SHELL'
     '';
  };
}
