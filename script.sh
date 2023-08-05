#!/bin/bash

sudo su
echo "juliano	ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
usermod -G root juliano
usermod -G juliano root
cd /opt/

sudo echo "#!/bin/bash \n
ls --color=always --group-directories-first -1plArths |awk '{print \$4,\$5,\$2,\$6,\$7,\$8,\$9,\$10}' |column -t" > /usr/bin/myls
sudo chmod +x /usr/bin/myls

sed -i 's/^HISTCONTROL=ignoreboth/HISTCONTROL=ignoreboth:erasedups/g' ~/.bashrc
sed -i '/^HISTCONTROL=ignoreboth/a export export HISTTIMEFORMAT="<%F %T> (${original_user:-$USER}) "' ~/.bashrc
sed -i '/^HISTCONTROL=ignoreboth/a export original_user=${SUDO_USER:-$(pstree -Alsu "$$" | sed -n "s/.*(\([^)]*\)).*($USER)[^(]*$/\1/p")}' ~/.bashrc
sed -i 's/^HISTSIZE=1000/HISTSIZE=1000000/g' ~/.bashrc
sed -i 's/^HISTFILESIZE=2000/HISTFILESIZE=2000000/g' ~/.bashrc
sed -i '/if \[ "\$color_prompt" = yes \]; then/i \
Branch=`git branch 2> \/dev\/null | sed -e "s|^[^*]*\* \(.*\)\$|\\1|" -e "s|.*|(&)|"`\
Line1="\\\\n\\[\\033[38;5;6m\\]\\d\\[\\033[38;5;6m\\] \\t\\[\\033[38;5;1m\\] \\[\\[\\033[38;5;11m\\]\\s\\[\\033[38;5;1m\\]\\] \\[\\033[38;5;1m\\]{\\[\\033[38;5;11m\\]\\$?\\[\\033[38;5;1m\\]}" \$Branch\
Line2="\\\\n\\[\\$(tput sgr0)\\]\\[\\033[38;5;11m\\]\\u\\[\\$(tput sgr0)\\]\\[\\033[38;5;9m\\]@\\[\\$(tput sgr0)\\]\\[\\033[38;5;27m\\]\\h\\[\\033[38;5;11m\\]:\\[\\033[38;5;39m\\]\\w"\
Line3="\\\\n\\\\\\$\\[\\$(tput sgr0)\\] \\[\\$(tput sgr0)\\]"\
PROMPT="\$(echo -e \"\$Line1 \$Line2 \$Line3 \$Line4\")"\n' ~/.bashrc
sed -i '/PS1=/s/.*/PS1=$PROMPT/' ~/.bashrc
sed -i '/\.dircolors/a alias ls='\''myls'\''\nalias dir='\''myls'\''\nalias ll='\''myls'\''\nalias la='\''myls'\''\nalias l='\''myls'\''\nalias grep='\''egrep --color=auto'\''\nalias fgrep='\''fgrep --color=auto'\''\nalias egrep='\''egrep --color=auto'\''\nalias vgrep='\''egrep -v --color=auto'\''\nalias k='\''kubectl'\''\nalias kgp='\''kubectl get pod'\''\nalias kgn='\''kubectl get node'\''\nalias gpl='\''git pull'\''\nalias gcl='\''git clone'\''\nalias gck='\''git checkout'\''\nalias gbr='\''git branch -a'\''\nalias gad='\''git add .'\''\nalias gcm='\''git commit'\''\nalias gps='\''git push'\''\nalias gft='\''git fetch'\''\nalias gup='\''git add . && git commit -m "update" && git push'\''\nalias tfp='\''terraform plan'\''\nalias tfv='\''terraform validate'\''\nalias tfa='\''terraform apply'\''\nalias tfi='\''terraform import'\''\nalias tsp='\''terraspace plan'\''\nalias tsv='\''terraspace validate'\''\nalias tsa='\''terraspace apply'\''\nalias tsi='\''terraspace import'\''' ~/.bashrc

wget -c https://cdn.lwks.com/releases/2022.3/lightworks_2022.3_r136244.deb -O lwks.deb && dpkg -i lwks.deb
dpkg -i mysql-apt-config_0.8.25-1_all.deb
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

apt -y install kubernetes docker.io terraform mysql-workbench-community mc synaptic gparted vlc inkscape gimp sweethome3d openscad conky-all screenfetch ncal rosegarden ardour audacity hydrogen notepadqq lutris gparted remmina terminator tmux net-utils dnsutils nfs-common openssh-server git

apt install -f
apt update
apt -y upgrade

curl -fsSL https://get.docker.com | bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl

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

cd /home/juliano/Downloads/Install
for i in `ls |grep .deb |awk '{print $8}'; do dpkg -i && apt -f install; done