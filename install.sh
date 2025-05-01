#!/bin/bash

packages=(
  compton
  python
  python-i3ipc
  git
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
  kitty
  bluez
  blueman
  exa
)

function make_dirs(){
     echo "Creating Necessary Directories"

     mkdir ~/Downloads
     mkdir ~/Workspace
     mkdir ~/Pictures 
}

function install_packages(){
     echo "Installing Necessary Packages"

     sudo pacmaN -Syu
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

if [ $USER == 'root' ]
then
	echo "Don't run that script as root"
else
	echo "Kuruluyor ustam"
     make_dirs()
     install_packages()
     copy_configs()
fi


echo "Suggested Steps:
     - Install Yay
     - Enable Bluetooth
"
