#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "This script should be run as root or with sudo."
    exit 1
fi

USERNAME=$(cat sc_vars.ini |grep USERNAME |cut -d= -f2)
PASSWORD=$(cat sc_vars.ini |grep PASSWORD |cut -d= -f2)
STORAGE=$(cat sc_vars.ini |grep STORAGE |cut -d= -f2)
ARCHITECTURE=$(cat sc_vars.ini |grep ARCHITECTURE |cut -d= -f2)
WINDOWMANAGER=$(cat sc_vars.ini |grep WINDOWMANAGER |cut -d= -f2)
HOSTNAME=$(cat sc_vars.ini |grep HOSTNAME |cut -d= -f2)
NETWORKIP=$(cat sc_vars.ini |grep NETWORKIP |cut -d= -f2)
PREFIX=$(cat sc_vars.ini |grep PREFIX |cut -d= -f2)
GATEWAYIP=$(cat sc_vars.ini |grep GATEWAYIP |cut -d= -f2)
NAMESERVER1=$(cat sc_vars.ini |grep NAMESERVER1 |cut -d= -f2)
NAMESERVER2=$(cat sc_vars.ini |grep NAMESERVER2 |cut -d= -f2)
WIFIPASSWORD=$(cat sc_vars.ini |grep WIFIPASSWORD |cut -d= -f2)
WIFISSID=$(cat sc_vars.ini |grep WIFISSID |cut -d= -f2)
PACKAGES=$(cat sc_vars.ini |grep PACKAGES |cut -d= -f2)

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$STORAGE" ] || [ -z "$ARCHITECTURE" ] || [ -z "$WINDOWMANAGER" ] || [ -z "$HOSTNAME" ]; then
    echo "At least one variable are empty, please check sc_vars.ini file to confirm."
    exit 1
fi

echo "USERNAME:" $USERNAME
echo "PASSWORD:" $PASSWORD
echo "ARCHTECT:" $ARCHITECTURE
echo "WINDOW M:" $WINDOWMANAGER
echo "HOSTNAME:" $HOSTNAME
echo "NETWORKIP:" $NETWORKIP
echo "GATEWAYIP:" $GATEWAYIP
echo "NAMESERVER1:" $NAMESERVER1
echo "NAMESERVER2:" $NAMESERVER2
echo "WIFIPASSWORD:" $WIFIPASSWORD
echo "STORAGE:" $STORAGE

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
	pacman --noconfirm -S git base-devel
	pacman --noconfirm -S git
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	yay -S pamac
	pacman --noconfirm -S paru
	pamac enable AUR
    pacman --noconfirm -Syy
    pacman --noconfirm -Syyu
    pacman --noconfirm -S --needed xorg lightdm lightdm-gtk-greeter acpid networkmanager connman
    systemctl enable dhcpcd
    systemctl enable sshd
    systemctl enable lightdm
    systemctl enable NetworkManager
    systemctl enable connman
    systemctl enable acpid
    case "$1" in
        "mate")
            pacman --noconfirm -S --needed mate-desktop mate-session-manager mate-panel mate-control-center mate-extra mate-applet-dock mate-applet-streamer caja marco
            ;;
        "plasma")
            pacman --noconfirm -S --needed plasma plasma-desktop plasma-wayland-session kde-applications
            ;;
        "gnome")
            pacman --noconfirm -S --needed gnome gnome-extra gnome-tweaks
            ;;
        "xfe")
            pacman --noconfirm -S --needed xfce4 xfce4-goodies
            ;;
        "lxde")
            pacman --noconfirm -S --needed pacman -S lxdm
            ;;
        "afterstep")
            pacman --noconfirm -S --needed afterstep
            ;;
        "enlightenment")
                pacman --noconfirm -S efl
                pacman --noconfirm -S enlightenment
                pacman --noconfirm -S --needed firefox vlc filezilla leafpad xscreensaver archlinux-wallpaper 
                pacman --noconfirm -S ecrire ephoto evisum rage terminology
            ;;
        *)
            echo "Window Manager not recognized.: $1"
            echo "Window Manager can be like this: mate afterstep enlightenment xfce lxde plasma gnome"
            ;;
    esac
}

func_confirm_disk() {
  while true; do
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
                UEFI="${DISK}p1"
                BOOT="${DISK}p2"
                ROOT="${DISK}p3"
            else
                UEFI="${DISK}1"
                BOOT="${DISK}2"
                ROOT="${DISK}3"
            fi
        else
            echo "Invalid storage device: $STORAGE"
            exit 1
        fi
        echo "STORAGE :" $TYPE
        echo "DEVICE  :" $DISK
        echo "PartUEFI:" $UEFI
        echo "PartBOOT:" $BOOT
        echo "PartROOT:" $ROOT
        read -rp "All done to proceed? (Y/N): " response
    else
        if [ -e "/dev/sda" ]; then
            TYPE="SATA"
            DISK="/dev/sda"
            UEFI="$DISK"1
            BOOT="$DISK"2
            ROOT="$DISK"3
        elif [ -e "/dev/xvda" ]; then
            TYPE="Virtual SATA"
            DISK="/dev/xvda"
            UEFI="$DISK"1
            BOOT="$DISK"2
            ROOT="$DISK"3
        elif [ -e "/dev/nvme0n1" ]; then
            TYPE="NVMe"
            DISK="/dev/nvme0n1"
            UEFI="${DISK}p1"
            BOOT="${DISK}p2"
            ROOT="${DISK}p3"
        else
            echo "STORAGE :" $TYPE
            echo "DEVICE  :" $DISK
            echo "PartUEFI:" $UEFI
            echo "PartBOOT:" $BOOT
            echo "PartROOT:" $ROOT
            read -rp "All done to proceed? (Y/N): " response
        fi
        echo "STORAGE :" $TYPE
        echo "DEVICE  :" $DISK
        echo "PartUEFI:" $UEFI
        echo "PartBOOT:" $BOOT
        echo "PartROOT:" $ROOT
        read -rp "All done to proceed? (Y/N): " response
    fi
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
    echo "STORAGE :" $TYPE
    echo "DEVICE  :" $DISK
    echo "PartBOOT:" $BOOT
    echo "PartUEFI:" $UEFI
    echo "PartROOT:" $ROOT
    lsblk -o NAME,MOUNTPOINT,SIZE,FSUSED,FSAVAIL,FSUSE%,FSTYPE
}

func_cable_cfg() {
    ETHNIC=$(ip -f inet -o link | awk -F ': ' '{print $2}' | grep -Ev 'w|lo')
    ip link set dev $ETHNIC up
    ip route addr add $NETWORKIP/$PREFIX dev $ETHNIC
    ip route add default via $GATEWAYIP
    echo $NAMESERVER1 > /etc/resolv.conf
    echo $NAMESERVER2 >> /etc/resolv.conf
    echo $HOSTNAME > /etc/hostname
    echo '127.0.0.1     localhost'  > /etc/hosts
    echo '::1           localhost'  >> /etc/hosts
    echo '127.0.1.1	    myarch'     >> /etc/hosts
}

func_wifi_cfg() {
    rfkill unblock wifi
    rfkill list
    systemctl restart iwd.service
    ADAPTER=$(iwctl device list |awk 'NR==5 {print $2}')
    iwctl station $ADAPTER scan
    iwctl station $ADAPTER get-networks
    iwctl --passphrase $WIFIPASSWORD station $ADAPTER connect $WIFISSID
    ip link set dev $ADAPTER up
    ip route addr add $NETWORKIP/$PREFIX dev $ADAPTER
    ip route add default via $GATEWAYIP
    echo $NAMESERVER1 > /etc/resolv.conf
    echo $NAMESERVER2 >> /etc/resolv.conf
    echo $HOSTNAME > /etc/hostname
    echo '127.0.0.1     localhost'  > /etc/hosts
    echo '::1           localhost'  >> /etc/hosts
    echo '127.0.1.1	    myarch'     >> /etc/hosts
}

func_lvm_raid() {
    modprobe raid1
	modprobe dm-mod
	sed -i '/^MODULES=/c\MODULES="vmd dm-raid dm-mod raid1"' /etc/mkinitcpio.conf
	mkinitcpio -P
	grub-install
    echo "need a reboot to grant the changes"
	pvcreate /dev/nvme1n1
	pvcreate /dev/nvme2n1
	vgcreate vg_data /dev/nvme1n1 /dev/nvme2n1
	lvcreate --mirrors 1 --type raid1 -l 100%FREE -n lv_data vg_data
	mkdir /FS /FS/DATA /FS/BACK /FS/GAME
	chown $USERNAME:$USERNAME /FS -R
	if ! grep -q '/dev/vg_data/lv_data' /etc/fstab; then
		echo "/dev/vg_data/lv_data /FS/DATA ext4 defaults,noatime 0 0" >> /etc/fstab
	fi
	if ! grep -q '/dev/nvme0n1p1' /etc/fstab; then
		echo "/dev/nvme0n1p1 /FS/GAME ext4 defaults,noatime 0 0" >> /etc/fstab
	fi
	if ! grep -q '/dev/sdb1' /etc/fstab; then
		echo "/dev/sdb1 /FS/BACK btrfs defaults,nofail,noatime 0 0" >> /etc/fstab
	fi
}

func_chaotic() {
    pacman --noconfirm -Syy
	pacman --noconfirm -Syyu
	pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	pacman-key --lsign-key 3056513887B78AEB
	pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
	if ! grep -q '^\[chaotic-aur\]$' /etc/pacman.conf || ! grep -q '^Include = /etc/pacman.d/chaotic-mirrorlist$' /etc/pacman.conf; then
	    echo "[chaotic-aur]" | tee -a /etc/pacman.conf
	    echo "Include = /etc/pacman.d/chaotic-mirrorlist" | tee -a /etc/pacman.conf
	    echo "Added the [chaotic-aur] section and Include line."
	else
	    echo "The [chaotic-aur] Repo is already available."
	fi
}

func_pamac_yay() {
	pacman --noconfirm -Syy
	pacman --noconfirm -Syyu
	pacman --noconfirm -S git base-devel
	pacman --noconfirm -S git
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	yay -S pamac
	pacman --noconfirm -S paru
	pamac enable AUR
}

func_mariadb() {
	pacman --noconfirm -S mariadb mariadb-clients
	DBDIRS='/var/lib/mysql /var/lib/mariadb /var/run/mysqld /var/run/mariadb /run/mariadb /run/mysqld'
	for var in $DBDIRS;
	do
		rm -Rf $var
		mkdir $var
		chown mysql:mysql $var
		chown mysql:mysql $var -R
		chmod 744 $var -R
	done
	mariadb-install-db --user=mysql --basedir=/usr/bin --datadir=/var/lib/mysql

	mariadb -u root -p -e "CREATE DATABASE conky;"
	mariadb -u root -p -e "CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD';"
	mariadb -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO '$USERNAME'@'localhost';"
	mariadb -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$PASSWORD';"
	mariadb -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';"
	mariadb -u root -p$PASSWORD -e "CREATE USER 'conky'@'localhost' IDENTIFIED BY '$PASSWORD';"
	mariadb -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON conky.* TO 'conky'@'localhost';"
	systemctl restart mariadb
}

func_install() {
	echo "" > error.log
	pacman --noconfirm -S simple-scan
	paru MFC-L2710DW
	paru brscan4
	yay -S --mflags --skipinteg openlens-bin
	yay -Sy --noconfirm franz
	yay -S --noconfirm arc-gtk-theme
	for var in $PACKAGES;
	do
		clear
		echo 'Installing - '$var
		pacman --noconfirm -S $var 2>> error.log
	done
	modprobe i2c_piix4
	modprobe i2c-i801
	modprobe i2c_dev
	modprobe snd_aloop
	pacman -R xdg-desktop-portal-gnome
	pacman -Rns $(pacman -Qtdq)
}

func_linux_amd() {
	pacman --noconfirm -S xf86-video-fbdev
	pacman --noconfirm -S xf86-video-ati
	pacman --noconfirm -S xf86-video-amdgpu
	modprobe fbdev
	modprobe ati
	modprobe amdgpu
}

func_linux_nvidia() {
	pacman --noconfirm -S xf86-video-fbdev
	pacman --noconfirm -S nvidia
	modprobe fbdev
	modprobe nvidia
}

func_archlinux_installation() {
    set -e

    if [ -e "$UEFI" ]; then
        echo 'Removing Partition' "$UEFI"
        parted --script -f "$DISK" rm 1
    else
        echo 'UEFI partition does not exist.'
    fi

    if [ -e "$BOOT" ]; then
        echo 'Removing Partition' "$BOOT"
        parted --script -f "$DISK" rm 2
    else
        echo 'BOOT partition does not exist.'
    fi

    if [ -e "$ROOT" ]; then
        echo 'Removing Partition' "$ROOT"
        parted --script -f "$DISK" rm 3
    else
        echo 'ROOT partition does not exist.'
    fi
    parted --script -f $DISK mklabel gpt
    parted --script -f $DISK mkpart primary fat32 1MiB 501MiB
    parted --script -f $DISK set 1 esp on
    parted --script -f $DISK mkpart primary btrfs 501MiB 1501MiB
    parted --script -f $DISK mkpart primary btrfs 1501MiB 100%
    mkfs.fat -F32 $UEFI
    mkfs.ext4 -F $BOOT
    mkfs.ext4 -F $ROOT
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
    pacstrap /mnt base linux linux-firmware vim nano nano dhcpcd net-tools grub efibootmgr openssh
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
    hwclock --systohc
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    export LANG=en_US.UTF-8
    if ip link show eth0 | grep -q "state UP"; then
        func_cable_cfg
    else
        if iwconfig 2>/dev/null | grep -q "IEEE 802.11"; then
            func_wifi_cfg
        else
            echo "Not available an WiFi interface."
        fi
    fi
    passwd < $PASSWOR
    useradd -m $USERNAM
    passwd $USERNAM < $PASSWOR
    usermod -aG wheel,audio,video,storage,root $USERNAM
	usermod -G $USERNAME root
    FULLNAME=$(cat /etc/passwd |grep $USERNAME |cut -d: -f5)
	sed -i "s|$USERNAME:x:1000:1000:$FULLNAME:/home/$USERNAME:/bin/bash|$USERNAME:x:1000:1000:$FULLNAME:/FS/DATA/$USERNAME:/bin/zsh|g" /etc/passwd
    echo "$USERNAM ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    sed -i 's/^#%wheel  ALL=(ALL:ALL) ALL$/%wheel  ALL=(ALL:ALL) ALL/' /etc/sudoers
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
    echo "Invalid argument: $1. Use the following variables below:"
    echo "initial - will run all commands to install archlinux using all variables set in the script"
    echo "raid - to set lvm softraid between 2 NVMe (1/2)"
    echo "pamac - install pamac and yay"
    echo "chaotic - enable CHAOTIC AUR repo"
    echo "packages - install a huge list of packages"
    echo "mariadb - configure mariadb instance"
    exit 1
fi