
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins - order matters
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add in snippets
zinit snippet OMZP::command-not-found

# Load completions
fpath+=~/.zfunc
fpath+=~/.zsh/completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^H' backward-kill-word

bindkey "\e[1;7D" backward-word
bindkey "\e[1;7C" forward-word

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -al --git --color=always --group-directories-first $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -al --git --color=always --group-directories-first $realpath'

# Aliases
# alias ls="eza"
# alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first -s Name'
# alias ll='eza -al --no-user --total-size --git --icons=always --color=always --group-directories-first -s Name'
# alias ll='eza -al --no-user --git --icons=always --color=always --group-directories-first -s Name'
alias ls='eza -al --no-user --git --icons=always --color=always --group-directories-first -s Name'
alias lt='eza --git --icons=always --color=always --tree --group-directories-first -s Name'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias lg='ll | grep' 

alias np='nvim .'
alias nn='nvim'

dev() {
    local current_dir="$PWD"

    osascript <<EOF
tell application "Ghostty"
    activate

    set cfg to new surface configuration
    set initial working directory of cfg to "$current_dir"

    set win to new window with configuration cfg

    -- TAB 1 (nvim)
    set tab1 to selected tab of win
    set term1 to terminal 1 of tab1
    input text "nvim ." to term1
    send key "enter" to term1

    -- TAB 2 (pi)
    tell application "System Events"
        keystroke "t" using command down
    end tell
    delay 0.2

    set tab2 to selected tab of win
    set term2 to terminal 1 of tab2
    input text "pi" to term2
    send key "enter" to term2

    -- TAB 3 (tuxedo)
    tell application "System Events"
        keystroke "t" using command down
    end tell
    delay 0.2

    set tab3 to selected tab of win
    set term3 to terminal 1 of tab3
    input text "touch todo.txt && tuxedo" to term3
    send key "enter" to term3

    -- TAB 4 (shell)
    tell application "System Events"
        keystroke "t" using command down
    end tell
    delay 0.2

    set tab4 to selected tab of win

end tell
EOF
}

alias pio-init_proj='f() {pio project init --ide vim --board $1 ; pio run -t compiledb};f'

# PATH
export PATH="/Users/dylankamstra/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/dylankamstra/.bun/bin:$PATH"
export HOMEBREW_NO_ENV_HINTS=1

# Exports
export EDITOR="nvim"
export VISUAL="nvim"

# Shell integrations
# FZF
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
# This has control-r fuzzy finding
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# eval "(fzf --zsh)"

# zoxide
export _ZO_EXCLUDE_DIRS="*src:*build"
# eval "$(zoxide init --cmd zd zsh)"
eval "$(zoxide init --cmd zd zsh --hook none)"
export _ZO_FZF_OPTS="--height=100% --layout=reverse"
_zoxide_add_except_worktree() {
  [[ -f $PWD/.git && ! -d $PWD/.bare ]] && return
  zoxide add "$PWD"
}

precmd_functions+=(_zoxide_add_except_worktree)

# # Per-directory todo display
# _todo_show() {
#   local todo_file="$PWD/.todo.toml"
#   [[ -f "$todo_file" ]] || return
#
#   local RESET="" CYAN="" BOLD="" GREEN="" YELLOW="" RED=""
#   if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
#     RESET=$'\033[0m'
#     CYAN=$'\033[36m'
#     BOLD=$'\033[1m'
#     GREEN=$'\033[32m'
#     YELLOW=$'\033[33m'
#     RED=$'\033[31m'
#   fi
#
#   awk -v DIR="$PWD" -v RESET="$RESET" -v CYAN="$CYAN" -v BOLD="$BOLD" \
#       -v GREEN="$GREEN" -v YELLOW="$YELLOW" -v RED="$RED" '
#     function repeat(ch, n, s, i) { for (i = 0; i < n; i++) s = s ch; return s }
#     function bar(p, width, filled, fill_color) {
#       width = 20
#       if (p < 0) p = 0
#       if (p > 100) p = 100
#       filled = int(p * width / 100)
#       if (p >= 67) fill_color = GREEN
#       else if (p >= 34) fill_color = YELLOW
#       else fill_color = RED
#       return "[" fill_color repeat("=", filled) RESET repeat("-", width - filled) "]"
#     }
#     function header() {
#       if (!header_printed) {
#         printf "\n%s%s%s .todo.toml%s\n", CYAN, BOLD, DIR, RESET
#         header_printed = 1
#       }
#     }
#     function print_task() {
#       header()
#       # Pad t_title so all bars line up
#       printf "• %-35s %s %d%%\n", t_title, bar(t_progress), t_progress
#     }
#     function print_sub() {
#       header()
#       # Pad s_title so all bars line up
#       printf "  - %-35s %s %d%%\n", s_title, bar(s_progress), s_progress
#     }
#     /^[[:space:]]*#/ { next }
#     /^[[:space:]]*\[\[tasks\]\]/ {
#       if (sub_seen) { print_sub(); sub_seen = 0 }
#       if (task_seen && !task_printed) { print_task() }
#       task_seen = 1; task_printed = 0; in_sub = 0
#       t_title = "(untitled)"; t_progress = 0
#       next
#     }
#     /^[[:space:]]*\[\[tasks\.subtasks\]\]/ {
#       if (sub_seen) { print_sub() }
#       if (task_seen && !task_printed) { print_task(); task_printed = 1 }
#       in_sub = 1; sub_seen = 1
#       s_title = "(untitled)"; s_progress = 0
#       next
#     }
#     /^[[:space:]]*title[[:space:]]*=/ {
#       line = $0
#       sub(/^[[:space:]]*title[[:space:]]*=[[:space:]]*"/, "", line)
#       sub(/".*/, "", line)
#       if (in_sub) s_title = line
#       else t_title = line
#       next
#     }
#     /^[[:space:]]*progress[[:space:]]*=/ {
#       line = $0
#       sub(/^[[:space:]]*progress[[:space:]]*=[[:space:]]*/, "", line)
#       sub(/[^0-9].*/, "", line)
#       if (in_sub) s_progress = line + 0
#       else t_progress = line + 0
#       next
#     }
#     END {
#       if (sub_seen) print_sub()
#       if (task_seen && !task_printed) print_task()
#     }
#   ' "$todo_file"
# }
#
# # chpwd_functions=(${chpwd_functions:#_todo_show})
# chpwd_functions+=(_todo_show)

# Source files
eval "$(starship init zsh)"
eval "$(try init ~/src/tries)"

# if [ "$TERM" != "screen" ] && [ -z "$TMUX" ]; then
#     tmux attach -t default || tmux new-session -s default
# fi

eval "$(mise activate zsh)"
