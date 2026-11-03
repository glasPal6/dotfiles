# Relaunch the TUIs/editors that were running in a tuios pane before the
# daemon restarted. tuios resurrect gives each window a fresh shell in its saved
# cwd with TUIOS_RESTORED=1 and the same TUIOS_WINDOW_ID, so:
#   preexec  -> record the command per window
#   precmd   -> forget it once it exits normally (a crash/daemon kill never gets here)
#   startup  -> if TUIOS_RESTORED=1 and a record exists, run it at the first prompt
[[ -o interactive && -n "$TUIOS_WINDOW_ID" ]] || return 0

# First words (after alias expansion) worth restoring
typeset -ga TUIOS_RESTORE_CMDS
(( ${#TUIOS_RESTORE_CMDS} )) || TUIOS_RESTORE_CMDS=(nvim vim vi claude lazygit btop htop yazi k9s)

_tuios_restore_file="${XDG_STATE_HOME:-$HOME/.local/state}/tuios-restore/$TUIOS_WINDOW_ID"

_tuios_restore_preexec() {
    local -a words=(${(z)3})
    (( ${TUIOS_RESTORE_CMDS[(Ie)${words[1]:t}]} )) || return 0
    mkdir -p "${_tuios_restore_file:h}"
    print -r -- "$3" >| "$_tuios_restore_file"
}

_tuios_restore_precmd() {
    rm -f "$_tuios_restore_file"
}

# One-shot: type the saved command into the first prompt and run it
_tuios_restore_run() {
    add-zle-hook-widget -d line-init _tuios_restore_run
    [[ -n "$_tuios_restore_cmd" ]] || return 0
    BUFFER=$_tuios_restore_cmd
    unset _tuios_restore_cmd
    zle accept-line
}

if [[ "$TUIOS_RESTORED" == 1 ]]; then
    # Consume the flag so child shells (inside nvim, new splits) don't re-fire
    unset TUIOS_RESTORED
    if [[ -r "$_tuios_restore_file" ]]; then
        _tuios_restore_cmd=$(<"$_tuios_restore_file")
        rm -f "$_tuios_restore_file"
        autoload -Uz add-zle-hook-widget
        zle -N _tuios_restore_run
        add-zle-hook-widget line-init _tuios_restore_run
    fi
fi

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tuios_restore_preexec
add-zsh-hook precmd _tuios_restore_precmd
