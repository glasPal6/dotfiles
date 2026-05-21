
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
    tmux new-window -n "pi-agent" -c "$current_dir" "pi"

    # Create a new window for a shell
    tmux new-window -n "shell" -c "$current_dir"

    # Select the nvim window for focus
    tmux select-window -t "$base_name"
}

alias pio-init_proj='f() {pio project init --ide vim --board $1 ; pio run -t compiledb};f'

# PATH
export PATH="/Users/dylankamstra/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
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
_zoxide_add_except_worktree() {
  [[ -f $PWD/.git && ! -d $PWD/.bare ]] && return
  zoxide add "$PWD"
}

precmd_functions+=(_zoxide_add_except_worktree)

# Per-directory todo display
_todo_show() {
  local todo_file="$PWD/.todo.toml"
  [[ -f "$todo_file" ]] || return
  python3 - "$todo_file" <<'PY'
import os
import sys
from pathlib import Path

path = Path(sys.argv[1])
try:
    import tomllib
except Exception:  # pragma: no cover
    import tomli as tomllib  # type: ignore

USE_COLOR = sys.stdout.isatty() and os.environ.get("NO_COLOR") is None

def color(code: str) -> str:
    return f"\033[{code}m" if USE_COLOR else ""

RESET = color("0")
CYAN = color("36")
BOLD = color("1")
GREEN = color("32")
YELLOW = color("33")
RED = color("31")


def bar(percent: int, width: int = 20) -> str:
    percent = max(0, min(100, percent))
    filled = int((percent / 100) * width)
    if percent >= 67:
        fill_color = GREEN
    elif percent >= 34:
        fill_color = YELLOW
    else:
        fill_color = RED
    filled_part = f"{fill_color}{'=' * filled}{RESET}"
    empty_part = "-" * (width - filled)
    return "[" + filled_part + empty_part + "]"

data = tomllib.loads(path.read_text())
tasks = data.get("tasks", [])
if not tasks:
    sys.exit(0)

print(f"\n{CYAN}{BOLD}{path.parent} .todo.toml{RESET}")
for task in tasks:
    title = str(task.get("title", "(untitled)"))
    progress = int(task.get("progress", 0))
    print(f"• {title} {bar(progress)} {progress}%")
    for sub in task.get("subtasks", [])[:]:
        stitle = str(sub.get("title", "(untitled)"))
        sprogress = int(sub.get("progress", 0))
        print(f"  - {stitle} {bar(sprogress)} {sprogress}%")
PY
}

chpwd_functions=(${chpwd_functions:#_todo_show})
chpwd_functions+=(_todo_show)


# Source files
eval "$(starship init zsh)"
eval "$(try init ~/src/tries)"

if [ "$TERM" != "screen" ] && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new-session -s default
fi

eval "$(mise activate zsh)"
