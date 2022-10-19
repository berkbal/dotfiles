#!/bin/bash

echo "Installing Necessary Packages"
pacman -Syu
pacman -S compton python git pavucontrol thunar alacritty syslog-ng cronie

echo "Polybar theme should be installed manually"
echo "Polybar Themes: https://github.com/adi1090x/polybar-themes"

# Copy Process
cp -r alacritty ~/.config/
cp -r i3 ~/.config/
cp -r nvim ~/.config/

cp .bash_profile ~/
cp .bashrc ~/
cp xinitrc ~/

cp compton.conf ~/.config

