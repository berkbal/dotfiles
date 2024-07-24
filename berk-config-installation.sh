#!/bin/bash

echo "Installing Necessary Packages"
sudo pacman -Syu
sudo pacman -S compton python python-i3ipc git pavucontrol nautilus alacritty syslog-ng cronie pfetch neovim vim rofi nitrogen wget curl polybar keychain

mkdir ~/Downloads
mkdir ~/Workspace
mkdir ~/Pictures

# Copy Process
cp -r alacritty ~/.config/
cp -r i3 ~/.config/
cp -r nvim ~/.config/
cp -r polybar ~/.config/

cp .bash_profile ~/
cp .bashrc ~/

cp compton.conf ~/.config

echo "Settings copied."
echo "Suggested Steps:
     - Install Yay
     - Install Stacer
"
