# aliases

alias p="sudo pacman"
alias tr="setxkbmap tr"
alias en="setxkbmap us"
alias ka="killall"
alias vim="nvim"
alias ls='ls --color=auto'
alias exploit='searchsploit'
	
# Startup Commands
pfetch

# Variables
export PATH=/opt/firefox/firefox:$PATH

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[01;30m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Hewals

#eval $(keychain --eval --quiet id_rsa)
#
if [[ -z $DISPLAY && $(tty) == /dev/tty1 && $XDG_SESSION_TYPE == tty ]]; then
  MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
fi

alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'
