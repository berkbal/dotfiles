#!/bin/bash

echo "Installing Necessary Packages"
pacman -Syu
pacman -S compton python polybar git pavucontrol
echo "Polybar theme should be installed manually"
echo "Polybar Themes: https://github.com/adi1090x/polybar-themes"
