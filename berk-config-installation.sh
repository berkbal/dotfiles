#!/bin/bash

echo "Installing Necessary Packages"
pacman -Syu
pacman -S compton python python-i3ipc git pavucontrol nautilus alacritty syslog-ng cronie firefox neofetch nvim vim rofi nitrogen wget curl polybar

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
