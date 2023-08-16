#!/bin/bash

sudo echo "$USERNAME	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers.d/1000-$USERNAME
USERNAME=`sudo cat /etc/passwd |grep '1000:1000' |cut -d: -f 1`
packages='terraform mysql-workbench-community mc synaptic gparted vlc inkscape gimp sweethome3d openscad conky-all screenfetch ncal rosegarden ardour audacity hydrogen notepadqq lutris gparted remmina terminator tmux net-utils dnsutils nfs-common openssh-server git zsh fish lm-sensors curl netcat-traditional net-tools sqlite3'

sudo usermod -G root $USERNAME
sudo usermod -G $USERNAME root

sudo mkdir /FS_DATA
sudo mkdir /FS_BACK
sudo mkdir /FS_GAME

sudo chown $USERNAME:$USERNAME /FS_DATA -R
sudo chown $USERNAME:$USERNAME /FS_BACK -R
sudo chown $USERNAME:$USERNAME /FS_GAME -R

sudo cp /FS_DATA/$USERNAME/.git/linux/myls /usr/bin/myls
chmod +x /usr/bin/myls

SymLinks() {
	cd /home/$USERNAME
for var in `cat /home/$USERNAME/.config/user-dirs.dirs |grep -v '#' |cut -d/ -f 2 |cut -d\" -f1`
	do
		rm -Rf /home/$USERNAME/$var
		ln -s /FS_DATA/$USERNAME/$var /home/$USERNAME/$var
	done
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
	rm -Rf /home/$USERNAME/.config/Notepadqq
	rm -Rf /home/$USERNAME/.config/OpenRGB
	rm -Rf /home/$USERNAME/.config/OpenSCAD
	rm -Rf /home/$USERNAME/.config/Todoist
	rm -Rf /home/$USERNAME/.config/VirtualBox
	ln -s /FS_DATA/$USERNAME/Mozilla /home/$USERNAME/Mozilla
	ln -s /FS_DATA/$USERNAME/.brweather /home/$USERNAME/.brweather
	ln -s /FS_DATA/$USERNAME/.git /home/$USERNAME/.git
	ln -s /FS_DATA/$USERNAME/.ssh /home/$USERNAME/.ssh
	ln -s /FS_DATA/$USERNAME/.openrgb /home/$USERNAME/.openrgb
	ln -s /FS_DATA/$USERNAME/.oh-my-zsh /home/$USERNAME/.oh-my-zsh
	ln -s /FS_DATA/$USERNAME/.bashrc /home/$USERNAME/.bashrc
	ln -s /FS_DATA/$USERNAME/.bash_logout /home/$USERNAME/.bash_logout
	ln -s /FS_DATA/$USERNAME/.bash_profile /home/$USERNAME/.bash_profile
	ln -s /FS_DATA/$USERNAME/.bash_history /home/$USERNAME/.bash_history
	ln -s /FS_DATA/$USERNAME/.zshrc /home/$USERNAME/.zshrc
	ln -s /FS_DATA/$USERNAME/.zsh_history /home/$USERNAME/.zsh_history
	ln -s /FS_DATA/$USERNAME/.zshrc.pre-oh-my-zsh /home/$USERNAME/.zshrc.pre-oh-my-zsh
	ln -s /FS_DATA/$USERNAME/.config/fish /home/$USERNAME/.config/fish
	ln -s /FS_DATA/$USERNAME/.config/Franz /home/$USERNAME/.config/Franz
	ln -s /FS_DATA/$USERNAME/.config/mc /home/$USERNAME/.config/mc
	ln -s /FS_DATA/$USERNAME/.config/Notepadqq /home/$USERNAME/.config/Notepadqq
	ln -s /FS_DATA/$USERNAME/.config/OpenRGB /home/$USERNAME/.config/OpenRGB
	ln -s /FS_DATA/$USERNAME/.config/OpenSCAD /home/$USERNAME/.config/OpenSCAD
	ln -s /FS_DATA/$USERNAME/.config/Todoist /home/$USERNAME/.config/Todoist
	ln -s /FS_DATA/$USERNAME/.config/VirtualBox /home/$USERNAME/.config/VirtualBox
}

install_packages() {
    distro=$(cat /etc/os-release | grep '^ID_LIKE=' | cut -d'=' -f2)
    case $distro in
        "ubuntu" | "debian")
            cd /tmp
            sudo apt-get update
            sudo apt-get install -y $packages
            wget -c https://cdn.lwks.com/releases/2022.3/lightworks_2022.3_r136244.deb -O lwks.deb && dpkg -i lwks.deb
            wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

            apt update
            apt -y upgrade

            apt -y install $packages
            apt install -f

            curl -fsSL https://get.docker.com | bash
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            chmod +x kubectl
            mv kubectl /usr/bin/.

            echo 'Package: snapd' > /etc/apt/preferences.d/nosnap.pref
            echo 'Pin: release a=*' >> /etc/apt/preferences.d/nosnap.pref
            echo 'Pin-Priority: -1' >> /etc/apt/preferences.d/nosnap.pref

            sudo snap list | awk '{print $1}' | awk 'NR>=2'
            if [ $? -eq 0 ]; then
              for i in $(sudo snap list | awk '{print $1}' | awk 'NR>=2'); do
                sudo snap remove --purge $i
              done
            fi
            sudo systemctl stop snapd
            sudo apt remove --autoremove snapd
            sudo apt purge snapd

            sudo apt install --install-suggests gnome-software
            sudo echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
            sudo echo 'Package: firefox*' > /etc/apt/preferences.d/mozillateamppa
            sudo echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozillateamppa
            sudo echo 'Pin-Priority: 501' >> /etc/apt/preferences.d/mozillateamppa
            sudo add-apt-repository -y ppa:mozillateam/ppa
            sudo apt update
            sudo apt install -y -t 'o=LP-PPA-mozillateam' firefox thunderbird

            sudo apt -y install ffmpeg
            sudo add-apt-repository ppa:obsproject/obs-studio
            sudo apt update
            sudo apt install obs-studio
            ;;
        "centos" | "redhat" | "fedora")
            sudo yum update
            sudo yum install -y $packages
            ;;
        "arch" | "manjaro" | "garuda")
            sudo pacman -Syu
            sudo pacman -S $packages
            ;;
        "suse")
            sudo zypper refresh
            sudo zypper install -y $packages
            ;;
        *)
            echo "Distribuição não suportada."
            exit 1
            ;;
    esac
}

# Chama a função para instalar os pacotes
install_packages
