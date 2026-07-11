
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
    zellij action rename-tab "nvim"
    zellij action new-tab --cwd . --name "pi" -- pi
    zellij action new-tab --cwd . --name "tuxedo" -- bash -c "touch todo.txt && tuxedo"
    zellij action new-tab --cwd . --name "term"
    zellij action go-to-tab 0
    nvim .
}

alias pio-init_proj='f() {pio project init --ide vim --board $1 ; pio run -t compiledb};f'

alias ssh="env TERM=xterm-256color COLORTERM=truecolor ssh"

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

# Zellij
export ZELLIJ_SOCKET_DIR=/tmp/zellij

# Try
export TRY_PATH=~/Documents/Experiments

# Source files
eval "$(starship init zsh)"
eval "$(try init ~/Documents/Experiments)"
eval "$(mise activate zsh)"

# if [ "$TERM" != "screen" ] && [ -z "$TMUX" ]; then
#     tmux attach -t default || tmux new-session -s default
# fi
if [[ -z "$ZELLIJ" ]]; then
    zellij attach Base --create
fi
