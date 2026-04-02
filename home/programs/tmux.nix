{
  pkgs,
  ...
}:
{
  # FIXME: battery not working
  home.packages = with pkgs; [ upower ];

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = false;
    escapeTime = 0;
    keyMode = "vi";
    newSession = true;
    prefix = "C-SPACE";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "\${TERM}";

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.battery;
        extraConfig = ''
          set -g @batt_icon_charge_tier8 '󰂂'
          set -g @batt_icon_charge_tier7 '󰂁'
          set -g @batt_icon_charge_tier6 '󰂀'
          set -g @batt_icon_charge_tier5 '󰁿'
          set -g @batt_icon_charge_tier4 '󰁾'
          set -g @batt_icon_charge_tier3 '󰁽'
          set -g @batt_icon_charge_tier2 '󰁻'
          set -g @batt_icon_charge_tier1 '󰁺'
          set -g @batt_icon_status_charging '󰂄'
          set -g status-right-length 50
          set -g status-right 'Batt: #{battery_icon} #{battery_percentage} | "#H" %a %d-%h %H:%M '
        '';
      }
    ];

    extraConfig = ''
      # [[ OPTIONS ]]
      set -as terminal-features "screen-256color:RGB"

      set -g renumber-windows on # automaticaly renumber-windows to fix gaps
      set -g status-position top # puts the status at the top
      set -g status-justify absolute-centre # center the bar
      set -g status-style "bg=default" # background of the header
      set -g window-status-current-style "fg=red bold" # current window
      set -g pane-active-border-style "fg=red" # active pane border

      # [[ BINDS ]]
      # easely reload config file
      bind r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded."

      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # vim keybinding for navigation
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind-key 'h' if-shell "$is_vim" 'send-keys C-SPACE h' { if -F '#{pane_at_left}' ''' 'select-pane -L' }
      bind-key 'j' if-shell "$is_vim" 'send-keys C-SPACE j' { if -F '#{pane_at_bottom}' ''' 'select-pane -D' }
      bind-key 'k' if-shell "$is_vim" 'send-keys C-SPACE k' { if -F '#{pane_at_top}' ''' 'select-pane -U' }
      bind-key 'l' if-shell "$is_vim" 'send-keys C-SPACE l' { if -F '#{pane_at_right}' ''' 'select-pane -R' }
      bind-key 'n' if-shell "$is_vim" 'send-keys C-SPACE n' { if -F '#{window_end_flag}' ''' 'select-window -n' }
      bind-key 'p' if-shell "$is_vim" 'send-keys C-SPACE p' { if 'test #{window_index} -gt #{base-index}' 'select-window -p' }

      bind -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 1'
      bind -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 1'
      bind -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 1'
      bind -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 1'
      bind-key -T copy-mode-vi M-h resize-pane -L 1
      bind-key -T copy-mode-vi M-j resize-pane -D 1
      bind-key -T copy-mode-vi M-k resize-pane -U 1
      bind-key -T copy-mode-vi M-l resize-pane -R 1

      bind -n 'C-M-h' if-shell "$is_vim" 'send-keys C-M-h' 'swap-pane -s "{left-of}"'
      bind -n 'C-M-j' if-shell "$is_vim" 'send-keys C-M-j' 'swap-pane -s "{down-of}"'
      bind -n 'C-M-k' if-shell "$is_vim" 'send-keys C-M-k' 'swap-pane -s "{up-of}"'
      bind -n 'C-M-l' if-shell "$is_vim" 'send-keys C-M-l' 'swap-pane -s "{right-of}"'
      bind-key -T copy-mode-vi C-M-h swap-pane -s "{left-of}"
      bind-key -T copy-mode-vi C-M-j swap-pane -s "{down-of}"
      bind-key -T copy-mode-vi C-M-k swap-pane -s "{up-of}"
      bind-key -T copy-mode-vi C-M-l swap-pane -s "{right-of}"


      bind y run "tmux neww -c '#{pane_current_path}' yazi"
      bind E show-environment -g # show environment vars
      bind f run "tmux neww ~/.config/scripts/tmux-session-dispensary.sh"
      bind H run "~/.config/scripts/tmux-session-dispensary.sh $HOME"
      bind D run "~/.config/scripts/tmux-session-dispensary.sh $HOME/dotfiles_stow/"
      bind N run "~/.config/scripts/tmux-session-dispensary.sh /etc/nixos/"
    '';
  };
}
