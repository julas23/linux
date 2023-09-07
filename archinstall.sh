#!/bin/bash

if [[ $(id -u) -eq 0 ]]; then
    echo "This script should not be run as root or with sudo."
    exit 1
fi

func_lvm_raid() {
	sudo pvcreate /dev/nvme1n1
	sudo pvcreate /dev/nvme2n1
	sudo vgcreate vg_data /dev/nvme1n1 /dev/nvme2n1
	sudo lvcreate --mirrors 1 --type raid1 -l 100%FREE -n lv_data vg_data
	sudo mkdir /FS /FS/DATA /FS/BACK /FS/GAME
	sudo chown $USER:$USER /FS -R
	if ! grep -q '/dev/vg_data/lv_data' /etc/fstab; then
		sudo echo "/dev/vg_data/lv_data /FS/DATA ext4 defaults,noatime 0 0" >> /etc/fstab
	fi
	if ! grep -q '/dev/nvme0n1p1' /etc/fstab; then
		sudo echo "/dev/nvme0n1p1 /FS/GAME ext4 defaults,noatime 0 0" >> /etc/fstab
	fi
	if ! grep -q '/dev/sdb1' /etc/fstab; then
		sudo echo "/dev/sdb1 /FS/BACK btrfs defaults,nofail,noatime 0 0" >> /etc/fstab
	fi
	if [ -e "/etc/sudoers.d/1000-$USER" ]; then
	    sudo echo "$USER    ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/1000-$USER
	fi
	sudo sed -i "s|$USER:x:1000:1000:Juliano Santos:/home/$USER:/bin/bash|$USER:x:1000:1000:Juliano Santos:/FS/DATA/$USER:/bin/zsh|g" /etc/passwd
	sudo usermod -G root $USER
	sudo usermod -G $USER root
	sudo modprobe raid1
	sudo modprobe dm-mod
	sed -i '/^MODULES=/c\MODULES="vmd dm-raid dm-mod raid1"' /etc/mkinitcpio.conf
	mkinitcpio -P
	grub-install
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

func_pamac_yay() {
	sudo pacman --noconfirm -Syy
	sudo pacman --noconfirm -Syyu
	sudo pacman -S git base-devel
	sudo pacman -S git
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	yay -S pamac
	sudo pacman --noconfirm -S paru
	sudo pamac enable AUR
}

func_mariadb() {
	sudo pacman --noconfirm -S mariadb mariadb-clients
	DBDIRS='/var/lib/mysql /var/lib/mariadb /var/run/mysqld /var/run/mariadb /run/mariadb /run/mysqld'
	for var in $DBDIRS;
	do
		sudo rm -Rf $var
		sudo mkdir $var
		sudo chown mysql:mysql $var
		sudo chown mysql:mysql $var -R
		sudo chmod 777 $var -R
	done
	sudo mariadb-install-db --user=mysql --basedir=/usr/bin --datadir=/var/lib/mysql

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
	PACKAGES='alacritty ansible ansible-core ardour audacity balena-etcher bash bash-completion bat bitwarden blender brave-bin cava cheese chromium code conky conky-manager containerd curl dbeaver dmidecode docker docker-compose dosbox elisa endeavour evolution evolution-data-server exa expect filezilla firedragon firefox fish franz-bin gimp git gnucash helm homebank htop hydrogen inkscape jdk-openjdk jre-openjdk kubectl latte-dock links lm_sensors lshw lsd lutris mc mysql-workbench nano nfs-utils notepadqq obs-studio openlens-bin openrgb openscad openssh opera pycharm python python-mysqlconnector python-pymysql qbittorrent remmina retroarch rosegarden rpi-imager screenfetch solaar sqlite steam sweethome3d terminator terraform thunar thunderbird tilix todoist virtualbox vlc xterm yay youtube-dl zsh yay paru xsane brother-mfc-l2710dw simple-scan linux-api-headers wine winetricks make patch electron19 python-mysql-connector python-pymysql consola xterm'
	sudo pacman --noconfirm -S simple-scan
	paru MFC-L2710DW
	paru brscan4
	yay -S --mflags --skipinteg openlens-bin
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
	sudo modprobe snd_aloop
	pacman -R xdg-desktop-portal-gnome
	pacman -Rns $(pacman -Qtdq)
}

func_archlinux() {
	set -e
	echo "Inform the device where Arch Linux must be Installed"
	read DEVICE
	parted $DEVICE mklabel gpt
	parted $DEVICE mkpart primary fat32 1MiB 501MiB
	parted $DEVICE set 1 esp on
	parted $DEVICE mkpart primary ext4 501MiB 100%
	parted $DEVICE quit

	mkfs.fat -F32 /dev/sda1
	mkfs.ext4 /dev/sda2

	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot/efi

	pacman -Syy
	pacman -S reflector
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
	reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
	pacstrap /mnt base linux linux-firmware vim nano
	genfstab -U /mnt >> /mnt/etc/fstab
	arch-chroot /mnt
	ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
	hwclock --systohc
	locale-gen
	echo "LANG=en_US.UTF-8" > /etc/locale.conf
	export LANG=en_GB.UTF-8
	echo ryzen > /etc/hostname
	echo '127.0.0.1	localhost' > /etc/hosts
	echo '::1		localhost' >> /etc/hosts
	echo '127.0.1.1	myarch' >> /etc/hosts
	passwd
	pacman -S grub
	grub-install --target=i386-pc /dev/sda2
	grub-mkconfig -o /boot/grub/grub.cfg
	umount -R /mnt
	reboot
}

func_linux_amd() {
	pacman -S xf86-video-fbdev
	pacman -S xf86-video-ati
	pacman -S xf86-video-amdgpu
	pacman --noconfirm -S xorg
	pacman --noconfirm -S mate-desktop mate-session-manager mate-panel mate-extra mate-applet-dock mate-applet-streamer caja marco
	pacman --noconfirm -S sddm
	modprobe fbdev
	modprobe ati
	modprobe amdgpu
}

func_linux_nvidia() {
	pacman -S xf86-video-fbdev
	pacman -S nvidia
	pacman --noconfirm -S xorg
	pacman --noconfirm -S mate-desktop mate-session-manager mate-panel mate-extra mate-applet-dock mate-applet-streamer caja marco 
	pacman --noconfirm -S sddm
	modprobe fbdev
	modprobe nvidia
}

if [ "$1" == "raid" ]; then
    func_lvm_raid
elif [ "$1" == "chaotic" ]; then
    func_chaotic
elif [ "$1" == "pamac" ]; then
    func_pamac_yay
elif [ "$1" == "mariadb" ]; then
    func_mariadb
elif [ "$1" == "install" ]; then
    func_install
elif [ "$1" == "archlinux" ]; then
    func_archlinux
elif [ "$1" == "linux" ]; then
    func_linux_amd
elif [ "$1" == "linux" ]; then
    func_linux_nvidia
else
    echo "Argumento inválido: $1. Use raid, chaotic, pacman, mariadb, install ou archlinux."
    exit 1
fi
