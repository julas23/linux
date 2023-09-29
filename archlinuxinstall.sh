#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "This script should be run as root or with sudo."
    exit 1
fi

USERNAME=$(cat data.ini |grep USERNAME |cut -d= -f2)
PASSWORD=$(cat data.ini |grep PASSWORD |cut -d= -f2)
STORAGE=$(cat data.ini |grep STORAGE |cut -d= -f2)
ARCHITECTURE=$(cat data.ini |grep ARCHITECTURE |cut -d= -f2)
WINDOWMANAGER=$(cat data.ini |grep WINDOWMANAGER |cut -d= -f2)
HOSTNAME=$(cat data.ini |grep HOSTNAME |cut -d= -f2)

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$STORAGE" ] || [ -z "$ARCHITECTURE" ] || [ -z "$WINDOWMANAGER" ] || [ -z "$HOSTNAME" ]; then
    echo "At least one variable are empty, please check data.ini file to confirm."
    exit 1
fi

echo "USERNAME:" $USERNAME
echo "PASSWORD:" $PASSWORD
echo "ARCHTECT:" $ARCHITECTURE
echo "WINDOW M:" $WINDOWMANAGER
echo "HOSTNAME:" $HOSTNAME
echo "STORAGE :" $TYPE
echo "DEVICE  :" $DISK
echo "PartBOOT:" $BOOT
echo "PartUEFI:" $UEFI
echo "PartROOT:" $ROOT

read -rp "All done to proceed? (Y/N): " response
case "$response" in
    [yY])
    echo 'Proceeding with install!'
    sleep 2
    clear
    ;;
    [nN])
    echo 'Aborted!'
    exit 1
    ;;
    *)
    echo "Please enter Y or N."
    ;;
esac

func_wm_install() {
    pacman --noconfirm -Syy
	pacman --noconfirm -Syyu
	pacman -S git base-devel
	pacman -S git
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	yay -S pamac
	sudo pacman --noconfirm -S paru
	sudo pamac enable AUR
    pacman -Syy
    pacman -Syyu
    pacman -S --needed xorg lightdm lightdm-gtk-greeter acpid networkmanager connman
    systemctl enable dhcpcd
    systemctl enable sshd
    systemctl enable lightdm
    systemctl enable NetworkManager
    systemctl enable connman
    systemctl enable acpid
    case "$1" in
        "mate")
            pacman -S --needed mate-desktop mate-session-manager mate-panel mate-control-center mate-extra mate-applet-dock mate-applet-streamer caja marco
            ;;
        "plasma")
            pacman -S --needed plasma plasma-desktop plasma-wayland-session kde-applications
            ;;
        "gnome")
            pacman -S --needed gnome gnome-extra gnome-tweaks
            ;;
        "xfe")
            pacman -S --needed xfce4 xfce4-goodies
            ;;
        "lxde")
            pacman -S --needed pacman -S lxdm
            ;;
        "afterstep")
            pacman -S --needed afterstep
            ;;
        "enlightenment")
                pacman -S efl
                pacman -S enlightenment
                pacman -S --needed firefox vlc filezilla leafpad xscreensaver archlinux-wallpaper 
                pacman -S ecrire ephoto evisum rage terminology
            ;;
        *)
            echo "Window Manager not recognized.: $1"
            echo "Window Manager can be like this: mate afterstep enlightenment xfce lxde plasma gnome"
            ;;
    esac
}

func_confirm_disk() {
  while true; do
    echo "Detected storage type: $TYPE"
    echo "Device name: $DISK"
    echo "Partition for BOOT:" $BOOT
    echo "Partition for UEFI:" $UEFI
    echo "Partition for ROOT:" $ROOT
    read -rp "Is this correct? (Y/N): " response
    case "$response" in
      [yY])
        break
        ;;
      [nN])
        exit 1
        ;;
      *)
        echo "Please enter Y or N."
        ;;
    esac
  done
    if [ -n "$STORAGE" ]; then
        if [ -e "$STORAGE" ]; then
            TYPE="Custom"
            DISK="$STORAGE"
                if [[ $DISK == *nvme* ]]; then
                BOOT="${DISK}p2"
                UEFI="${DISK}p1"
                ROOT="${DISK}p3"
                else
                BOOT="${DISK}2"
                UEFI="${DISK}1"
                ROOT="${DISK}3"
                fi
            func_confirm_disk
        else
            echo "Invalid storage device: $STORAGE"
            exit 1
        fi
    else
        if [ -e "/dev/sda" ]; then
            TYPE="SATA"
            DISK="/dev/sda"
            BOOT="$DISK"2
            UEFI="$DISK"1
            ROOT="$DISK"3
            func_confirm_disk
        elif [ -e "/dev/xvda" ]; then
            TYPE="Virtual SATA"
            DISK="/dev/xvda"
            BOOT="$DISK"2
            UEFI="$DISK"1
            ROOT="$DISK"3
            func_confirm_disk
        elif [ -e "/dev/nvme0n1" ]; then
            TYPE="NVMe"
            DISK="/dev/nvme0n1"
            BOOT="${DISK}p2"
            UEFI="${DISK}p1"
            ROOT="${DISK}p3"
            func_confirm_disk
        else
            func_confirm_disk
        fi
    fi
}

func_net_cfg() {
    ip link set dev enp2s0 up
    ip route addr add 192.168.0.30/27 dev enp2s0
    ip route add default via 192.168.0.1
    echo "8.8.8.8" > /etc/resolv.conf
    echo "1.1.1.1" >> /etc/resolv.conf
    echo $HOSTNAME > /etc/hostname
    echo '127.0.0.1     localhost'  > /etc/hosts
    echo '::1           localhost'  >> /etc/hosts
    echo '127.0.1.1	    myarch'     >> /etc/hosts
}

func_lvm_raid() {
    sudo modprobe raid1
	sudo modprobe dm-mod
	sed -i '/^MODULES=/c\MODULES="vmd dm-raid dm-mod raid1"' /etc/mkinitcpio.conf
	mkinitcpio -P
	grub-install
    echo "need a reboot to grant the changes"
	sudo pvcreate /dev/nvme1n1
	sudo pvcreate /dev/nvme2n1
	sudo vgcreate vg_data /dev/nvme1n1 /dev/nvme2n1
	sudo lvcreate --mirrors 1 --type raid1 -l 100%FREE -n lv_data vg_data
	sudo mkdir /FS /FS/DATA /FS/BACK /FS/GAME
	sudo chown $USERNAME:$USERNAME /FS -R
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
		sudo chmod 744 $var -R
	done
	sudo mariadb-install-db --user=mysql --basedir=/usr/bin --datadir=/var/lib/mysql

	sudo mariadb -u root -p -e "CREATE DATABASE conky;"
	sudo mariadb -u root -p -e "CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD';"
	sudo mariadb -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO '$USERNAME'@'localhost';"
	sudo mariadb -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$PASSWORD';"
	sudo mariadb -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';"
	sudo mariadb -u root -p$PASSWORD -e "CREATE USER 'conky'@'localhost' IDENTIFIED BY '$PASSWORD';"
	sudo mariadb -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON conky.* TO 'conky'@'localhost';"
	sudo systemctl restart mariadb
}

func_install() {
	echo "" > error.log
	PACKAGES='alacritty ansible ansible-core ardour audacity balena-etcher bash bash-completion bat bitwarden blender brave-bin cava cheese chromium code conky conky-manager containerd curl dbeaver dmidecode docker docker-compose dosbox elisa endeavour evolution evolution-data-server exa expect filezilla firedragon firefox fish franz-bin gimp git gnucash helm homebank htop hydrogen inkscape jdk-openjdk jre-openjdk kubectl latte-dock links lm_sensors lshw lsd lutris mc mysql-workbench nano nfs-utils notepadqq obs-studio openlens-bin openrgb openscad openssh opera pycharm python python-mysqlconnector python-pymysql qbittorrent remmina retroarch rosegarden rpi-imager screenfetch solaar sqlite steam sweethome3d terminator terraform thunar thunderbird tilix todoist virtualbox vlc xterm yay youtube-dl zsh yay paru xsane brother-mfc-l2710dw simple-scan linux-api-headers wine winetricks make patch electron19 python-mysql-connector python-pymysql consola xterm gksu breeze-gtk materia-gtk-theme papirus-icon-theme pop-icon-theme todoist-appimage system-config-printer gnu-netcat'
	sudo pacman --noconfirm -S simple-scan
	paru MFC-L2710DW
	paru brscan4
	yay -S --mflags --skipinteg openlens-bin
	yay -Sy --noconfirm franz
	yay -S --noconfirm arc-gtk-theme
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

func_linux_amd() {
	pacman -S xf86-video-fbdev
	pacman -S xf86-video-ati
	pacman -S xf86-video-amdgpu
	modprobe fbdev
	modprobe ati
	modprobe amdgpu
}

func_linux_nvidia() {
	pacman -S xf86-video-fbdev
	pacman -S nvidia
	modprobe fbdev
	modprobe nvidia
}

func_archlinux_installation() {
    set -e

    sudo parted $DISK mklabel gpt
    sudo parted $DISK mkpart primary fat32 1MiB 501MiB
    sudo parted $DISK set 1 esp on
    sudo parted $DISK mkpart primary btrfs 501MiB 1501MiB
    sudo parted $DISK mkpart primary btrfs 1501MiB 100%
    sudo parted $DISK quit

    mkfs.fat -F32 $UEFI
    mkfs.btrfs $BOOT
    mkfs.btrfs $ROOT

    mount $ROOT /mnt
    mkdir /mnt/boot
    mkdir /mnt/home
    mount $BOOT /mnt/boot
    mkdir /mnt/boot/efi
    mount $UEFI /mnt/boot/efi

    pacman -Syy
    pacman -S reflector
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
    pacstrap /mnt base linux linux-firmware vim nano nano dhcpcd net-tools grub efibootmgr sudo openssh
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
    hwclock --systohc
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    export LANG=en_US.UTF-8
    func_net_cfg

    passwd < $PASSWOR
    useradd -m $USERNAM
    passwd $USERNAM < $PASSWOR
    usermod -aG wheel,audio,video,storage,root $USERNAM
	sudo usermod -G $USERNAME root
	sudo sed -i "s|$USERNAME:x:1000:1000:$USERNAME Santos:/home/$USERNAME:/bin/bash|$USERNAME:x:1000:1000:$USERNAME Santos:/FS/DATA/$USERNAME:/bin/zsh|g" /etc/passwd
    echo "$USERNAM ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    sudo sed -i 's/^#%wheel  ALL=(ALL:ALL) ALL$/%wheel  ALL=(ALL:ALL) ALL/' /etc/sudoers
    GRUBLINE=$(cat /etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT=)
    if [[ $GRUBLINE != *"acpi_enforce_resources=lax"* ]]; then
        NEW_GRUBLINE="${GRUBLINE%\"}\" acpi_enforce_resources=lax\""
        sed -i "s/$GRUBLINE/$NEW_GRUBLINE/" /etc/default/grub
    fi
    grub-install --target=x86_64-efi $BOOT
    grub-mkconfig -o /boot/grub/grub.cfg
    mkinitcpio -p linux
}

if [ "$1" == "raid" ]; then
    func_lvm_raid
elif [ "$1" == "chaotic" ]; then
    func_chaotic
elif [ "$1" == "pamac" ]; then
    func_pamac_yay
elif [ "$1" == "mariadb" ]; then
    func_mariadb
elif [ "$1" == "packages" ]; then
    func_install_packages
elif [ "$1" == "initial" ]; then
    func_confirm_disk
    func_archlinux_installation
    func_wm_install
elif [ "$1" == "amd" ]; then
    func_linux_amd
elif [ "$1" == "nvidia" ]; then
    func_linux_nvidia
else
    echo "Argumento inválido: $1. Use the following variables below:"
    echo "raid - to set lvm softraid between 2 NVMe (1/2)"
    echo "chaotic - enable CHAOTIC AUR repo"
    echo "pamac - install pamac and yay"
    echo "mariadb - configure mariadb instance"
    echo "packages - install a huge list of packages"
    echo "initial - will run all commands to install archlinux using all variables set in the script"
    exit 1
fi