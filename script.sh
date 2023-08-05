#!/bin/bash

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

echo "$USER	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
usermod -G root $USER
usermod -G $USER root
cd /tmp/

cp myls /usr/bin/.
chmos +x /usr/bin/myls

cat .bashrc > /home/$USER/.bashrc
cat .bashrc > /root/.bashrc
cat .bashrc > /etc/skel/.bashrc

wget -c https://cdn.lwks.com/releases/2022.3/lightworks_2022.3_r136244.deb -O lwks.deb && dpkg -i lwks.deb
dpkg -i mysql-apt-config_0.8.25-1_all.deb
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

apt update
apt -y upgrade

apt -y install terraform mysql-workbench-community mc synaptic gparted vlc inkscape gimp sweethome3d openscad conky-all screenfetch ncal rosegarden ardour audacity hydrogen notepadqq lutris gparted remmina terminator tmux net-utils dnsutils nfs-common openssh-server git
apt install -f

curl -fsSL https://get.docker.com | bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/bin/.

echo 'Package: snapd' > /etc/apt/preferences.d/nosnap.pref
echo 'Pin: release a=*' >> /etc/apt/preferences.d/nosnap.pref
echo 'Pin-Priority: -1' >> /etc/apt/preferences.d/nosnap.pref

snap list | awk '{print $1}' | awk 'NR>=2'
if [ $? -eq 0 ]; then
  for i in $(snap list | awk '{print $1}' | awk 'NR>=2'); do
    snap remove --purge $i
  done
fi
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
apt install -y -t 'o=LP-PPA-mozillateam' firefox thunderbird

apt -y install ffmpeg
add-apt-repository ppa:obsproject/obs-studio
apt update
apt install obs-studio