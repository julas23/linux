#!/bin/bash

pacman -Syy
pacman -Syyu
pacman -S pamac
pacman -S paru
pacman -S yay
pamac enable AUR
pacman -S simple-scan
paru MFC-L2710DW
paru brscan4

for var in $(cat arc_pkg_list); do pacman --noconfirm -S $var; done
