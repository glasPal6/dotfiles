# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
unalias r
unalias cd

export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/.go"

export _ZO_FZF_OPTS="--height 100% --layout=reverse --border"
alias pi='zi'
pin() {
    zi "$@" || return
    # Emit OSC 7 so Ghostty updates the directory
    printf '\033]7;file://%s%s\033\\' "${HOSTNAME:-localhost}" "${PWD// /%20}"
    nvim .
}

dev() {
    if [[ -z $TMUX ]]; then
        echo "You must be inside tmux to use 'dev'."
        return 1
    fi

    local current_dir="${PWD}"
    local base_name
    base_name="$(basename "$current_dir")"

    # Rename current window to project name and run nvim .
    tmux rename-window "editor"
    tmux send-keys -t "editor" "$EDITOR ." C-m

    # Create a new window for 'c'
    tmux new-window -n "opencode" -c "$current_dir" "opencode"

    # Create a new window for a shell
    tmux new-window -n "shell" -c "$current_dir"

    # Select the nvim window for focus
    tmux select-window -t "$base_name"
}

alias postgrad-login='sudo mount -t cifs -o user=u19090634 //up.ac.za/uplogin /mnt ; sudo umount /mnt'
alias pylonviewer='QT_QPA_PLATFORM=xcb QT_DEBUG_PLUGINS=1 /opt/pylon/bin/pylonviewer'

. "$HOME/.local/share/../bin/env"
