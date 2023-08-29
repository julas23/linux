#!/bin/bash

USERNAME=`sudo cat /etc/passwd |grep '1000:1000' |cut -d: -f 1`
#sudo echo "$USERNAME	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers.d/1000-$USERNAME
#sudo usermod -G root $USERNAME
#sudo usermod -G $USERNAME root
#sudo mkdir /FS/
#sudo mkdir /FS/DATA
#sudo mkdir /FS/BACK
#sudo mkdir /FS/GAME
#sudo chown $USERNAME:$USERNAME /FS -R
#sudo cp /FS/DATA/$USERNAME/.git/linux/myls /usr/bin/myls
#chmod +x /usr/bin/myls

cd /home/$USERNAME
rm -Rf /home/$USERNAME/Desktop
rm -Rf /home/$USERNAME/Downloads
rm -Rf /home/$USERNAME/Templates
rm -Rf /home/$USERNAME/Public
rm -Rf /home/$USERNAME/Documents
rm -Rf /home/$USERNAME/Music
rm -Rf /home/$USERNAME/Pictures
rm -Rf /home/$USERNAME/Videos
rm -Rf /home/$USERNAME/Mozilla

rm -Rf /home/$USERNAME/.brweather
rm -Rf /home/$USERNAME/.git
rm -Rf /home/$USERNAME/.ssh
rm -Rf /home/$USERNAME/.openrgb
rm -Rf /home/$USERNAME/.oh-my-zsh
rm -Rf /home/$USERNAME/.bashrc
rm -Rf /home/$USERNAME/.bash_logout
rm -Rf /home/$USERNAME/.bash_profile
rm -Rf /home/$USERNAME/.bash_history
rm -Rf /home/$USERNAME/.zshrc
rm -Rf /home/$USERNAME/.zsh_history
rm -Rf /home/$USERNAME/.zshrc.pre-oh-my-zsh
rm -Rf /home/$USERNAME/.config/fish
rm -Rf /home/$USERNAME/.config/Franz
rm -Rf /home/$USERNAME/.config/mc
rm -Rf /home/$USERNAME/.config/lsd
rm -Rf /home/$USERNAME/.config/Notepadqq
rm -Rf /home/$USERNAME/.config/OpenRGB
rm -Rf /home/$USERNAME/.config/OpenSCAD
rm -Rf /home/$USERNAME/.config/Todoist
rm -Rf /home/$USERNAME/.config/VirtualBox

ln -s /FS/DATA/$USERNAME/Desktop /home/$USERNAME/Desktop
ln -s /FS/DATA/$USERNAME/Downloads /home/$USERNAME/Downloads
ln -s /FS/DATA/$USERNAME/Templates /home/$USERNAME/Templates
ln -s /FS/DATA/$USERNAME/Public /home/$USERNAME/Public
ln -s /FS/DATA/$USERNAME/Documents /home/$USERNAME/Documents
ln -s /FS/DATA/$USERNAME/Music /home/$USERNAME/Music
ln -s /FS/DATA/$USERNAME/Pictures /home/$USERNAME/Pictures
ln -s /FS/DATA/$USERNAME/Videos /home/$USERNAME/Videos
ln -s /FS/DATA/$USERNAME/Mozilla /home/$USERNAME/Mozilla

ln -s /FS/DATA/$USERNAME/.brweather /home/$USERNAME/.brweather
ln -s /FS/DATA/$USERNAME/.git /home/$USERNAME/.git
ln -s /FS/DATA/$USERNAME/.ssh /home/$USERNAME/.ssh
ln -s /FS/DATA/$USERNAME/.openrgb /home/$USERNAME/.openrgb
ln -s /FS/DATA/$USERNAME/.oh-my-zsh /home/$USERNAME/.oh-my-zsh
ln -s /FS/DATA/$USERNAME/.bashrc /home/$USERNAME/.bashrc
ln -s /FS/DATA/$USERNAME/.bash_logout /home/$USERNAME/.bash_logout
ln -s /FS/DATA/$USERNAME/.bash_profile /home/$USERNAME/.bash_profile
ln -s /FS/DATA/$USERNAME/.bash_history /home/$USERNAME/.bash_history
ln -s /FS/DATA/$USERNAME/.zshrc /home/$USERNAME/.zshrc
ln -s /FS/DATA/$USERNAME/.zsh_history /home/$USERNAME/.zsh_history
ln -s /FS/DATA/$USERNAME/.zshrc.pre-oh-my-zsh /home/$USERNAME/.zshrc.pre-oh-my-zsh
ln -s /FS/DATA/$USERNAME/.config/fish /home/$USERNAME/.config/fish
ln -s /FS/DATA/$USERNAME/.config/Franz /home/$USERNAME/.config/Franz
ln -s /FS/DATA/$USERNAME/.config/mc /home/$USERNAME/.config/mc
ln -s /FS/DATA/$USERNAME/.config/lsd /home/$USERNAME/.config/lsd
ln -s /FS/DATA/$USERNAME/.config/Notepadqq /home/$USERNAME/.config/Notepadqq
ln -s /FS/DATA/$USERNAME/.config/OpenRGB /home/$USERNAME/.config/OpenRGB
ln -s /FS/DATA/$USERNAME/.config/OpenSCAD /home/$USERNAME/.config/OpenSCAD
ln -s /FS/DATA/$USERNAME/.config/Todoist /home/$USERNAME/.config/Todoist
ln -s /FS/DATA/$USERNAME/.config/VirtualBox /home/$USERNAME/.config/VirtualBox
ln -s /FS/DATA/$USERNAME/.todo /home/$USERNAME/.todo
