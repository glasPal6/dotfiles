# Backup command for system
alias backup-system='echo sudo rsync -aAXHv --filter=\"merge .backup.filter\" / /path/to/dest' 

# Quick vscode command to open current directory
alias codep='code .'
alias codex='code . ; exit'

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

# Login command for the ISG postgrad labs
	# Needs a network card to work on the network
	# /mnt is a temporary mount space
alias postgrad-login='nmcli radio wifi off; sudo mount -t cifs -o user=u19090634 //up.ac.za/uplogin /mnt ; sudo umount /mnt'
alias postgrad-exit='nmcli radio wifi on'
alias postgrad-cluster_login='ssh -X u19090634@137.215.159.216'
alias postgrad-beast_login='ssh -X dylank@137.215.158.253'
