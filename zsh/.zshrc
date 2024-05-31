# Start tmux
# if [ -z "$TMUX" ]
# then
#     tmux attach -t Base-Session || tmux new -s Base-Session
# fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins - order matters
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add in snippets
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Source the prompt
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

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
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:complete:cd:*' popup-min-size 150 12
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -al --git --color=always --group-directories-first $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -al --git --color=always --group-directories-first $realpath'

# Aliases
alias ls="eza"
alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first'
alias ll='eza -al --git --color=always --group-directories-first'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias lg='ll | grep' 

alias np='nvim .'
alias nn='nvim'

alias performance-off='sudo auto-cpufreq --force=reset'
alias performance-on='sudo auto-cpufreq --force=performance'

alias quick-update='sudo apt-get update ; sudo apt-get upgrade ; sudo apt-get autoremove ; sudo snap refresh'

alias pio-init_proj='f() {pio project init --ide vim --board $1 ; pio run -t compiledb};f'

alias postgrad-login='nmcli radio wifi off; sudo mount -t cifs -o user=u19090634 //up.ac.za/uplogin /mnt ; sudo umount /mnt'
alias postgrad-exit='nmcli radio wifi on'
alias postgrad-cluster_login='ssh -X u19090634@137.215.159.216'
alias postgrad-beast_login='ssh -X dylank@137.215.158.253'

# Exports
export EDITOR="nvim"
export VISUAL="nvim"

export PATH="$HOME/.local/bin:$PATH"

export QSYS_ROOTDIR="/home/dylan/intelFPGA_lite/quartus/sopc_builder/bin"
export ADB=/usr/bin/adb 
export MODULAR_HOME="/home/dylan/.modular"
export MOJO_PYTHON_LIBRARY=$(modular config mojo.python_lib)
export PATH="/home/dylan/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH="/opt/aseprite:$PATH"

export MODULAR_HOME="/home/dylan/.modular"
export PATH="/home/dylan/.modular/pkg/packages.modular.com_max/bin:$PATH"
export MODULAR_HOME="/home/dylan/.modular"
export PATH="/home/dylan/.modular/pkg/packages.modular.com_max/bin:$PATH"
export MODULAR_HOME="/home/dylan/.modular"
export PATH="/home/dylan/.modular/pkg/packages.modular.com_max/bin:$PATH"

export MMWAVE_SDK_TOOLS_INSTALL_PATH=/home/dylan/Documents/University/Masters_things/Radar_Dev/TI_Programs/mmWaveSDK/mmWaveSDK_Install_2
export MMWAVE_SDK_DEVICE=iwr14xx
export DOWNLOAD_FROM_CCS=yes
export MMWAVE_SDK_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/mmwave_sdk_02_01_00_04/packages
export R4F_CODEGEN_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/ti-cgt-arm_16.9.6.LTS
export XDC_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/xdctools_3_50_04_43_core
export BIOS_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/bios_6_53_02_00/packages
export XWR14XX_RADARSS_IMAGE_BIN=${MMWAVE_SDK_INSTALL_PATH}/../firmware/radarss/xwr12xx_xwr14xx_radarss_rprc.bin
export C674_CODEGEN_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/ti-cgt-c6000_8.1.3
export C64Px_DSPLIB_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/dsplib_c64Px_3_4_0_0
export C674x_DSPLIB_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/dsplib_c674x_3_4_0_0
export C674x_MATHLIB_INSTALL_PATH=${MMWAVE_SDK_TOOLS_INSTALL_PATH}/mathlib_c674x_3_1_2_1
export XWR16XX_RADARSS_IMAGE_BIN=${MMWAVE_SDK_INSTALL_PATH}/../firmware/radarss/xwr16xx_radarss_rprc.bin

# Shell integrations
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export _ZO_EXCLUDE_DIRS="*src:*build"
eval "$(zoxide init --cmd zd zsh)"

