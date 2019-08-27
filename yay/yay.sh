#!/usr/bin/env bash
# Install yay on a fresh copy of arch
# Needs sudo and base-devel!

su - $(whoami)
tar -xvzf <(curl https://aur.archlinux.org/cgit/aur.git/snapshot/yay-bin.tar.gz)
cd yay-bin
makepkgs -s
sudo pacman -U *xz
yay -S yay-bin

