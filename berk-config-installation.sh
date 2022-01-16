#!/bin/bash

echo "Installing Necessary Packages"
pacman -Syu
pacman -S compton python polybar
