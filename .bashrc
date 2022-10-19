# aliases

alias p="sudo pacman"
alias tr="setxkbmap tr"
alias en="setxkbmap us"
alias ka="killall"
alias vim="nvim"
alias ls='ls --color=auto'

# Startup Commands
pfetch

# Variables
export PATH=/opt/firefox/firefox:$PATH

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[01;30m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Hewals

eval $(keychain --eval --quiet id_rsa)
