#!/bin/bash

echo "Installing Necessary Packages"
pacman -Syu
<<<<<<< HEAD
pacman -S compton python git pavucontrol nautilus alacritty syslog-ng cronie firefox neofetch nvim vim rofi
=======
pacman -S compton python git pavucontrol nautilus alacritty syslog-ng cronie firefox stacer neofetch nvim vim rofi
>>>>>>> 475dc93b61395987e2d5401132d35ca38edd4fa1

echo "Polybar theme should be installed manually"
echo "Polybar Themes: https://github.com/adi1090x/polybar-themes"

# Copy Process
cp -r alacritty ~/.config/
cp -r i3 ~/.config/
cp -r nvim ~/.config/

cp .bash_profile ~/
cp .bashrc ~/

cp compton.conf ~/.config

echo "Settings copied."
echo "Suggested Steps:
     - Install Yay
     - Install Stacer
"
