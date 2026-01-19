# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
export PATH="$HOME/.local/bin:$PATH"

export _ZO_FZF_OPTS="--height 100% --layout=reverse --border"
alias pi='zi'
pin() {
    zi "$@" || return
    # Emit OSC 7 so Ghostty updates the directory
    printf '\033]7;file://%s%s\033\\' "${HOSTNAME:-localhost}" "${PWD// /%20}"
    nvim .
}

. "$HOME/.local/share/../bin/env"
