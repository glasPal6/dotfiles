# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Start tmux.
zstyle ':z4h:' start-tmux      system 

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
# z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# Show tmux sessions on startup
function _tmux()
{
    if [[ $# == 0 ]] && command tmux ls >& /dev/null; then
        command tmux attach \; choose-tree -s
    else
        command tmux "$@"
    fi
}
alias tmux=_tmux

# Aliasese
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias lg='ll | grep' 

# Backup command for system
alias backup-system='echo sudo rsync -aAXHv --filter=\"merge .backup.filter\" / /path/to/dest' 

# Quick vscode command to open current directory
alias codep='code .'
alias codex='code . ; exit'
alias nn='nvim'

# Command to run a command in performance mode
alias performance-off='sudo auto-cpufreq --force=reset'
alias performance-on='sudo auto-cpufreq --force=performance'

# Command to download youtube audio with yt-dlp
alias yt-dlp-audio='yt-dlp -f 'ba' -x --audio-format mp3 --yes-playlist --write-thumbnail --embed-metadata'

# Quick update command
	# Pulls new packages
	# Puts new packages onto the system
	# Removes redundant packages
	# Updates any snap packages
alias quick-update='sudo apt-get update ; sudo apt-get upgrade ; sudo apt-get autoremove ; sudo snap refresh'


# Pio project
alias pio-init_proj='f() {pio project init --ide vim --board $1 ; pio run -t compiledb};f'

# Login command for the ISG postgrad labs
	# Needs a network card to work on the network
	# /mnt is a temporary mount space
alias postgrad-login='nmcli radio wifi off; sudo mount -t cifs -o user=u19090634 //up.ac.za/uplogin /mnt ; sudo umount /mnt'
alias postgrad-exit='nmcli radio wifi on'
alias postgrad-cluster_login='ssh -X u19090634@137.215.159.216'
alias postgrad-beast_login='ssh -X dylank@137.215.158.253'

export QSYS_ROOTDIR="/home/dylan/intelFPGA_lite/quartus/sopc_builder/bin"
export ADB=/usr/bin/adb 
export MODULAR_HOME="/home/dylan/.modular"
export MOJO_PYTHON_LIBRARY=$(modular config mojo.python_lib)
export PATH="/home/dylan/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH="/opt/aseprite:$PATH"

export EDITOR="nvim"
export VISUAL="nvim"

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
