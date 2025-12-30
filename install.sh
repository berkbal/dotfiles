#!/bin/bash

packages=(
  compton
  python
  python-i3ipc
  git
  base-devel
  pavucontrol
  nautilus
  alacritty
  syslog-ng
  cronie
  pfetch
  neofetch
  neovim
  vim
  rofi
  nitrogen
  wget
  curl
  polybar
  keychain
  waybar
  hyprpaper
  hyprlock
  kitty
  bluez
  bluez-utils
  blueman
  exa
  grim
  slurp
  wl-clipboard
)

function make_dirs(){
     echo "Creating Necessary Directories"

     mkdir -p ~/Downloads
     mkdir -p ~/Workspace
     mkdir -p ~/Pictures
}

function install_packages(){
     echo "Installing Necessary Packages"

     sudo pacman -Syu
     sudo pacman -S --noconfirm "${packages[@]}"
}

function copy_configs(){
     echo "Copying config files to ~/.config/"

     cp -r alacritty ~/.config/
     cp -r i3 ~/.config/
     cp -r nvim ~/.config/
     cp -r polybar ~/.config/
     cp -r hypr ~/.config/
     cp .bash_profile ~/
     cp .bashrc ~/
     cp compton.conf ~/.config
}

function enable_bluetooth(){
     echo "Enabling Bluetooth service"

     sudo systemctl enable bluetooth.service
     sudo systemctl start bluetooth.service
}

function install_yay(){
     echo "Installing Yay AUR Helper"

     git clone https://aur.archlinux.org/yay.git /tmp/yay
     cd /tmp/yay
     makepkg -si --noconfirm
     cd -
     rm -rf /tmp/yay
}

if [ "$USER" == 'root' ]
then
	echo "Don't run that script as root"
else
	echo "Kuruluyor ustam"
     make_dirs
     install_packages
     install_yay
     copy_configs
     enable_bluetooth
fi

echo "Kurulum tamamlandi!"
