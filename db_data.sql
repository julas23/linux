USE monitor;

INSERT INTO t_infra (inf_id, inf_rng, inf_nmk, inf_rpi, inf_pcr, inf_ssh) VALUES
('1', '192.168.100.', '255,255,255,0', '254', '200', 'go2ryzen');

INSERT INTO t_cmmnd (cmd_id, cmd_run, cmd_out) VALUES
('1', 'neofetch --off', ''),
('2', 'nvidia-smi', ''),
('3', 'lshw -class memory', ''),
('4', 'sensors', ''),
('5', 'dmidecode -t2', ''),
('6', 'dmidecode -t17', ''),
('7', 'clear', '');

INSERT INTO t_outpt (out_id, out_cmd, out_var, out_blk, out_det) VALUES
('1', '1', 'distroversion', '|awk ''NR==3 {print $2,$3,$4}''', ''),
('2', '1', 'kernelversion', '|awk ''NR==5 {print $2}''', ''),
('3', '1', 'x11resolution', '|awk ''NR==9 {print $2}''', ''),
('4', '1', 'graphic_envin', '|awk ''NR==10 {print $2,$3}''', ''),
('5', '1', 'envinrmanager', '|awk ''NR==11 {print $2,$3}''', ''),
('6', '1', 'envinrontheme', '|awk ''NR==12 {print $2}''', ' '),
('7', '1', 'gpu_manufactu', '|awk ''NR==16 {print $2,$3,$4,$5,$8}''', ''),
('8', '1', 'gpu_temperatu', '|awk ''NR==17 {print $2,$3,$4,$5,$6}''', ''),
('9', '1', 'mobo_modelver', '|awk ''NR==4 {print $2,$3,$4}''', ''),
('10', '2', 'gpu_temperatu', '|awk ''NR==10 {print $3}'' |cut -dC -f 1', ''),
('11', '3', 'mobo_ddr_slot', '|grep ''bank'' |wc -l', ''),
('12', '3', 'mobo_ddr_used', '|grep GiB |awk ''NR>=2'' |wc -l', ''),
('13', '3', 'mobo_ddr_size', '|grep GiB |awk ''NR==2'' |cut -d: -f 2 |cut -c 2,3,4,5,6', ''),
('14', '3', 'mobo_ddr_alls', '|grep GiB |awk ''NR==1'' |cut -d: -f 2 |cut -c 2,3,4,5,6', ''),
('15', '4', 'cpu_temperatu', '|grep Tctl |cut -d+ -f2 |cut -c ''1,2''', ''),
('16', '4', 'mobo_temperat', '|grep -wns acpi -A 2 |grep temp1 |cut -d+ -f2 |cut -c 1,2', ''),
('17', '4', 'fan1_rpm_spee', '|grep fan1 |awk ''{print $2}''', ''),
('18', '4', 'case_temperat', '|grep -wns isa -A 14 |grep temp1 |cut -d+ -f2 |cut -c 1,2', ''),
('19', '4', 'case_fan_rpms', '|grep fan3 |awk ''{print $2}''', ''),
('20', '5', 'mobo_manufact', '|grep ''Manufacturer'' |awk ''{print $2}''', ''),
('21', '6', 'memory_cloksp', '|grep Speed: |awk ''NR==1 {print $2}''', ''),
('22', '6', 'memory_slotty', '|grep -i ''Type: '' |grep -v ''Unknown'' |uniq |awk ''{print $2}''', ''),
('23', '7', 'python_calend', '$HOME/Git/linux/sc_data.py', '');

INSERT INTO t_todo (tod_id, tod_typ,tod_tex, ok) VALUES
('', '', '', 0);

INSERT INTO t_safe (var_id, var_nam, var_val) VALUES
('1', 'PYMODUL','tqdm matplotlib cartopy pillow mysql.connector pymysql'),
('2', 'PACKAGES','neofetch lib32-nvidia-utils alacritty ansible ansible-core ardour audacity balena-etcher bash bash-completion bat bitwarden blender brave-bin cava cheese chromium code conky conky-manager containerd curl dbeaver dmidecode docker docker-compose dosbox elisa endeavour evolution evolution-data-server exa expect filezilla firedragon firefox fish franz-bin gimp git gnucash helm homebank htop hydrogen inkscape jdk-openjdk jre-openjdk kubectl latte-dock links lm_sensors lshw lsd lutris mc mysql-workbench nano nfs-utils notepadqq obs-studio openlens-bin openrgb openscad openssh opera pycharm python python-mysqlconnector python-pymysql qbittorrent remmina retroarch rosegarden rpi-imager screenfetch solaar sqlite steam sweethome3d terminator terraform thunar thunderbird tilix todoist virtualbox vlc xterm yay youtube-dl zsh yay paru xsane brother-mfc-l2710dw simple-scan linux-api-headers wine winetricks make patch electron19 python-mysql-connector python-pymysql consola xterm gksu breeze-gtk materia-gtk-theme papirus-icon-theme pop-icon-theme todoist-appimage system-config-printer gnu-netcat');
