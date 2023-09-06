#!/bin/bash

if [[ $(id -u) -eq 0 ]]; then
    echo "This script should not be run as root or with sudo."
    exit 1
#else
#	if [ -e "/etc/sudoers.d/1000-$USER" ]; then
#	    sudo echo "$USER    ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/1000-$USER
#	fi
#	sudo sed -i "s|$USER:x:.*:.*:.*:/home/$USER:|$USER:x:1000:1000:.*:/FS/DATA/juliano:/bin/zsh|g" /etc/passwd
#	sudo usermod -G root $USER
#	sudo usermod -G $USER root
fi

func_lvm_raid() {
#	sudo pvcreate /dev/nvme1n1
#	sudo pvcreate /dev/nvme2n1
#	sudo vgcreate vg_data /dev/nvme1n1 /dev/nvme2n1
#	sudo lvcreate --mirrors 1 --type raid1 -l 100%FREE -n lv_data vg_data
	sudo mkdir /FS /FS/DATA /FS/BACK /FS/GAME
	sudo chown $USER:USERNAME /FS -R
	if ! grep -q '/dev/vg_data/lv_data' /etc/fstab; then
		sudo echo "/dev/vg_data/lv_data /FS/DATA ext4 defaults,noatime 0 0" >> /etc/fstab
	fi
	if ! grep -q '/dev/nvme0n1p1' /etc/fstab; then
		sudo echo "/dev/nvme0n1p1 /FS/GAME ext4 defaults,noatime 0 0" >> /etc/fstab
	fi
	if ! grep -q '/dev/sdb1' /etc/fstab; then
		sudo echo "/dev/sdb1 /FS/BACK btrfs defaults,nofail,noatime 0 0" >> /etc/fstab
	fi
}

func_chaotic() {
	sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	sudo pacman-key --lsign-key 3056513887B78AEB
	sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
	if ! grep -q '^\[chaotic-aur\]$' /etc/pacman.conf || ! grep -q '^Include = /etc/pacman.d/chaotic-mirrorlist$' /etc/pacman.conf; then
	    sudo echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf
	    sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
	    sudo echo "Added the [chaotic-aur] section and Include line."
	else
	    echo "The [chaotic-aur] Repo is already available."
	fi
}

func_pacman(){
	sudo pacman --noconfirm -S pamac
	sudo pacman --noconfirm -Syy
	sudo pacman --noconfirm -Syyu
	sudo pacman --noconfirm -S pamac
	sudo pacman --noconfirm -S paru
	sudo pacman --noconfirm -S yay
	sudo pamac enable AUR
}

func_mariadb() {
	sudo pacman --noconfirm -S mariadb mariadb-clients
	DBDIRS='/var/lib/mysql /var/lib/mariadb /var/run/mysqld /var/run/mariadb /var/run/mariadb'
	for var in $DBDIRS;
	do
		sudo rm -Rf $var
		sudo mkdir $var
		#sudo chattr +C $var
		#sudo chown mysql:mysql $var
		sudo chown mysql:mysql $var -R
		sudo chmod 777 $var -R
	done
	sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

	sudo mariadb -u root -p -e "CREATE DATABASE conky;"
	sudo mariadb -u root -p -e "CREATE USER 'juliano'@'localhost' IDENTIFIED BY 'jas2305X';"
	sudo mariadb -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO 'juliano'@'localhost';"
	sudo mariadb -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'jas2305X';"
	sudo mariadb -u root -pjas2305X -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';"
	sudo mariadb -u root -pjas2305X -e "CREATE USER 'conky'@'localhost' IDENTIFIED BY 'conky_db123';"
	sudo mariadb -u root -pjas2305X -e "GRANT ALL PRIVILEGES ON conky.* TO 'conky'@'localhost';"
	sudo systemctl restart mariadb
}

func_install() {
	echo "" > error.log
	PACKAGES='alacritty ansible ansible-core ardour audacity balena-etcher bash bash-completion bat bitwarden blender brave-bin cava cheese chromium code conky conky-manager containerd curl dbeaver dmidecode docker docker-compose dosbox elisa endeavour evolution evolution-data-server exa expect filezilla firedragon firefox fish franz-bin gimp git gnucash helm homebank htop hydrogen inkscape jdk-openjdk jre-openjdk kubectl latte-dock links lm_sensors lshw lsd lutris mc mysql-workbench nano nfs-utils notepadqq obs-studio openlens-bin openrgb openscad openssh opera pycharm python python-mysqlconnector python-pymysql qbittorrent remmina retroarch rosegarden rpi-imager screenfetch solaar sqlite steam sweethome3d terminator terraform thunar thunderbird tilix todoist virtualbox vlc xterm yay youtube-dl zsh yay paru xsane brother-mfc-l2710dw simple-scan linux-api-headers wine winetricks make patch electron19 python-mysql-connector python-pymysql'
	sudo pacman --noconfirm -S simple-scan
	paru MFC-L2710DW
	paru brscan4
	yay -S --mflags --skipinteg openlens-bin
	#yay -S --mflags --skipinteg franz-bin
	yay -Sy --noconfirm franz
	for var in $PACKAGES;
	do
		clear
		echo 'Installing - '$var
		sudo pacman --noconfirm -S $var 2>> error.log
	done
	sudo modprobe i2c_piix4
	sudo modprobe i2c-i801
	sudo modprobe i2c_dev
}

#func_lvm_raid
func_chaotic
func_pacman
#func_mariadb
func_install

pacman -R xdg-desktop-portal-gnome
pacman -Rns $(pacman -Qtdq)
