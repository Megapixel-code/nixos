# https://www.shellcheck.net/wiki/SC3046
# shellcheck disable=SC3000-SC4000

### source :
# aliases
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# syntax highlighting
# required : sudo apt install zsh-syntax-highlighting
[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# source rust; seems to not be needed on nix
# . "$CARGO_HOME/env"

### plugins :
# plugin list
plug_locations=(
   "$ZDOTDIR/plugins/zsh_vi_mode/zsh-vi-mode.plugin.zsh" # have a real vi mode in terminal
   "$ZDOTDIR/plugins/git-status/gitstatus.prompt.zsh" # have a real vi mode in terminal
)
# load plugins
for plug_loc in "${plug_locations[@]}"; do
   if [ -f "${plug_loc}" ]; then
      source "${plug_loc}"
   else
      echo "plugin not found at location : ${plug_loc}"
   fi
done


### load modules
autoload -U colors && colors
# autocomplete / completion list
autoload -U compinit && compinit
zmodload zsh/complist

# make electron work / enable the display for XWindows (didnt manage to do it)
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
# export DISPLAY=:0
# export ELECTRON_OZONE_PLATFORM_HINT=auto
# export ELECTRON_ENABLE_LOGGING=true


### history
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=100000
SAVEHIST=100000
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved


### completion options
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu

### settings
setopt no_case_glob no_case_match # make completion case insensitive
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt globdots # lets files beginning with a . be matched without explicitly specifying the dot
unsetopt autocd # dont autocd


### colors settings
if [ -x /usr/bin/dircolors ]; then
   test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
   alias ls='ls --color=auto'
   alias dir='dir --color=auto'
   alias vdir='vdir --color=auto'
   alias grep='grep --color=auto'
   alias fgrep='fgrep --color=auto'
   alias egrep='egrep --color=auto'
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


### custom prompt :
# get vim mode [require plugin zsh_vi_mode]
# The plugin will auto execute this zvm_after_select_vi_mode function
vim_mode="[I]"
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    "$ZVM_MODE_NORMAL")
      vim_mode="%F{blue}[N]%f"
    ;;
    "$ZVM_MODE_INSERT")
      vim_mode="%F{green}[I]%f"
    ;;
    "$ZVM_MODE_VISUAL")
      vim_mode="%F{purple}[V]%f"
    ;;
    "$ZVM_MODE_VISUAL_LINE")
      vim_mode="%F{purple}[V-L]%f"
    ;;
    "$ZVM_MODE_REPLACE")
      vim_mode="%F{red}[R]%f"
    ;;
  esac
} # ${vim_mode}

NEWLINE=$'\n' # ${NEWLINE}
GIT=$'$GITSTATUS_PROMPT' # ${GIT}
# PROMPT="${GIT}%n@%M %~ ${vim_mode}${NEWLINE}λ "
PROMPT="⌌ ${GIT}%F{blue}%n%f@%F{magenta}%M%f %F{cyan}%~%f
⌎ %F{red}λ%f "
zle && zle reset-prompt
