#!/bin/bash

apt install mc synaptic vlc inkscape gimp sweethome3d openscad conky-all screenfetch ncal rosegarden ardour6 audacity hydrogen notepadqq lutris gparted remmina terminator tmux net-utils dnsutils nfs-common openssh-server git
curl -fsSL https://get.docker.com | bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

export original_user=${SUDO_USER:-$(pstree -Alsu "$$" | sed -n "s/.*(\([^)]*\)).*($USER)[^(]*$/\1/p")}
export HISTTIMEFORMAT="<%F %T> (${original_user:-$USER}) "

echo 'Package: snapd' > /etc/apt/preferences.d/nosnap.pref
echo 'Pin: release a=*' >> /etc/apt/preferences.d/nosnap.pref
echo 'Pin-Priority: -1' >> /etc/apt/preferences.d/nosnap.pref

snap list |awk '{print $1}' |awk 'NR>=2'
for i in `snap list |awk '{print $1}' |awk 'NR>=2'`; do snap remove --purge $i;done
snap list |awk '{print $1}' |awk 'NR>=2'
snap remove --purge bare
snap remove --purge core20
snap remove --purge snapd
systemctl stop snapd
apt remove --autoremove snapd
apt purge snapd

apt install --install-suggests gnome-software
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
echo 'Package: firefox*' > /etc/apt/preferences.d/mozillateamppa
echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozillateamppa
echo 'Pin-Priority: 501' >> /etc/apt/preferences.d/mozillateamppa
add-apt-repository -y ppa:mozillateam/ppa
apt update
apt install -t 'o=LP-PPA-mozillateam' firefox thunderbird

add-apt-repository ppa:kirillshkrogalev/ffmpeg-next
apt-get update && sudo apt-get install ffmpeg
apt-get install ffmpeg
add-apt-repository ppa:obsproject/obs-studio
apt-get update && sudo apt-get install obs-studio

