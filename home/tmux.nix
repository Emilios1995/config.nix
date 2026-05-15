{ pkgs, lib, inputs, ... }:

let
  opensessionsDir = "$HOME/.tmux/plugins/opensessions";
  opensessionsSrc = inputs.opensessions;
in
{
  home.activation.opensessions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "${opensessionsDir}" ]; then
      mkdir -p "${opensessionsDir}"
    fi
    ${pkgs.rsync}/bin/rsync -a --delete "${opensessionsSrc}/" "${opensessionsDir}/"
    chmod -R u+w "${opensessionsDir}"
    cd "${opensessionsDir}" && ${pkgs.bun}/bin/bun install
  '';

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
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_current_text " #{window_name}"
          set -g @catppuccin_window_text " #{window_name}"
          set -g @catppuccin_window_default_text " #{window_name}"
        '';
      }
    ];

    extraConfig = ''
             set-option -g automatic-rename on
             set-option -g automatic-rename-format '#{?#{==:#{pane_current_command},zsh},#{b:pane_current_path},#{pane_current_command}}'
             set -as terminal-features ",xterm-256color:RGB"
             bind -T copy-mode-vi 'v' send -X begin-selection
             bind -T copy-mode-vi 'y' send -X copy-selection-and-cancel
             bind-key G new-window -n lazygit -c "#{pane_current_path}" direnv exec . lazygit
             bind-key A switch-client -l
             set -g default-command '$SHELL'
            bind-key "T" run-shell "sesh connect \"$(
            sesh list --icons | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
      )\""

      run-shell "bash ${opensessionsDir}/opensessions.tmux"
    '';
  };
}
