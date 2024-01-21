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
('1', 'note', 'NIF Juliano 315069430', 0),
('2', 'note', 'NIS Juliano 12168172481', 0),
('3', 'note', 'UTENTE Juliano 12168172481', 0),
('4', 'note', 'PASSPORT Juliano FU580336', 0),
('5', 'note', 'NIF Merilin 315344512', 0),
('6', 'note', 'NIS Merilin 121.715.097-94', 0),
('7', 'note', 'UTENTE Merilin 137589115', 0),
('8', 'note', 'PASSPORT Merilin GB320109', 0),
('9', 'note', 'NIF Leona 320038742', 0),
('10', 'note', 'UTENTE Leona 137761708', 0),
('11', 'note', 'PASSPORT Leona GG167442', 0),
('12', 'note', 'NIF Junior 319995330', 0),
('13', 'note', 'UTENTE Junior 137761677', 0),
('14', 'note', 'PASSPORT Junior GG167443', 0),
('15', 'note', 'Rua de Santana 12 4705-139 Braga', 0),
('16', 'note', 'Adesão 1139361 - Cc 0006 3845 0509', 0),
('17', 'note', 'Swift BESCPTPL - IBAN PT50000700000063845050923', 0),
('18', 'note', 'Adesão 1133971 - Cc 0006 8093 2144', 0),
('19', 'note', 'Swift BESCPTPL - IBAN PT50000700000068093214423', 0),
('20', 'task', 'Stunts', 0),
('21', 'task', '4DBox', 0),
('22', 'task', 'HocusPocus', 0),
('23', 'task', 'Another World', 0),
('24', 'task', 'Blood', 0),
('25', 'task', 'DragonsLair', 0),
('26', 'task', 'ZimaBoard MariaDB GitLab iVentoy Motion',  0),
('27', 'task', 'Caixa Lian Li O11 Dynamic XL ROG WaterCooler',  0),
('28', 'task', 'PSU Seasonic Focus+ 750W 80 Plus Gold Dock',  0),
('29', 'task', 'AMD EPYC™ Genoa 9124',  0),
('30', 'task', 'Custom Water Cooler',  0),
('31', 'task', 'Supermicro H13SSL-N',  0),
('32', 'task', 'Samsung 32GB DDR-5 4800Mhz Registered ECC',  0),
('33', 'task', 'AMD Radeon RX 7900 XTX',  0),
('34', 'task', 'Storage PCIe Blazing Quad M.2 Card',  0),
('35', 'task', '2x M2 NVMe 256Gb PCIe 5 x16 System',  0),
('36', 'task', '4x M2 MSI SPATIUM M570 PCIe 5.0 NVMe M.2 4TB',  0),
('37', 'task', 'Monitor Asus ROG Strix XG49VQ', 0),
('38', 'task', 'Creative Sound Blaster Audigy PCIe',  0),
('39', 'task', 'HomeTheater Sony Muteki HT-M7', 0),
('40', 'task', 'Hi-Fi Sony MHC-W777AV', 0);

INSERT INTO t_safe (var_id, var_nam, var_val) VALUES
('1', 'NIFJ','315069430'),
('2', 'NISJ','12168172481'),
('3', 'NISC','APQ-AAI-LY4'),
('4', 'UTENTEJ','12168172481'),
('5', 'PASSPORTJ','FU580336'),
('6', 'NIFM','315344512'),
('7', 'NISM','121.715.097-94'),
('8', 'UTENTEM','137589115'),
('9', 'PASSPORTM','GB320109'),
('10', 'NIFL','320038742'),
('11', 'UTENTEL','137761708'),
('12', 'PASSPORTL','GG167442'),
('13', 'NIFJJ','319995330'),
('14', 'UTENTEJJ','137761677'),
('15', 'PASSPORTJJ','GG167443'),
('16', 'OBCC','Código 02418343 - ES6700730100590797184681'),
('17', 'OBSI','Swift OPENESMM - IBAN ES6700730100590797184681'),
('18', 'NBJCC','Adesão 1139361 - Cc 0006 3845 0509'),
('19', 'NBJSI','Swift BESCPTPLXXX - IBAN PT50000700000063845050923'),
('20', 'NBACC','Adesão 1133971 - Cc 0006 8093 2144'),
('21', 'NBASI','Swift BESCPTPL - IBAN PT50000700000068093214423'),
('22', 'CCARD','4151 7500 6824 9159 08/24 954'),
('23', 'BitWarden','julianoas@msn.com / b+J@$.2305*12345'),
('24', 'OWACCESS','julianoas@msn.com / jas2305X'),
('25', 'OWAPI', '96191d21d3ba740890e070dec112bd0e'),
('26', 'OAIACCESS','julianoas@msn.com / o+J@$.2305*'),
('27', 'OAAPI','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'),
('28', 'MSN','julianoas@msn.com / m+J@$.2305* / kzxmrclbvubuovdr'),
('29', 'GOOGLE','julianoas@gmail.com / g+J@$.2305* / gskrpwqqnjsnbgtb'),
('30', 'ICLOUD','jueme@icloud.com / mas080483 / rsxy-hbfc-bcpz-jfyo'),
('31', 'APPLEKEY','HT5Q-J9FN-W2Q7-K5CP-U9J3-T7EG-JX4F'),
('32', 'SOURCE_DIRECTORY','/FS/DATA'),
('33', 'DESTINATION_DIRECTORY','/FS/BACK'),
('34', 'USERNAME','juliano'),
('35', 'PASSWORD','j+J@$.2305*'),
('36', 'ROOTPASS','l+J@$.2305*'),
('37', 'STORAGE','/dev/sda'),
('38', 'ARCHITECTURE','x86_64-efi'),
('39', 'WINDOWMANAGER','mate'),
('40', 'HOSTNAME','ryzen'),
('41', 'WIFIPASSWORD','J23.M08.L16.J16'),
('42', 'NETWORKIP','192.168.0.30'),
('43', 'PREFIX','27'),
('44', 'GATEWAYIP','192.168.0.1'),
('45', 'NAMESERVER1','8.8.8.8'),
('46', 'NAMESERVER2','1.1.1.1'),
('47', 'WIFISSID','Julas23'),
('48', 'DBCU','conky'),
('49', 'DBCP','conky_db123'),
('50', 'DBCH','192.168.100.254'),
('51', 'DBCN','conky'),
('52', 'DBSU','juliano'),
('53', 'DBSP','jas2305X'),
('54', 'DBSH','192.168.100.254'),
('55', 'DBSN','safe'),
('56', 'CITY','Braga'),
('57', 'API_KEY','96191d21d3ba740890e070dec112bd0e'),
('58', 'CKPLACE','conky'),
('59', 'PYMODUL','tqdm matplotlib cartopy pillow mysql.connector pymysql'),
('60', 'PACKAGES','neofetch lib32-nvidia-utils alacritty ansible ansible-core ardour audacity balena-etcher bash bash-completion bat bitwarden blender brave-bin cava cheese chromium code conky conky-manager containerd curl dbeaver dmidecode docker docker-compose dosbox elisa endeavour evolution evolution-data-server exa expect filezilla firedragon firefox fish franz-bin gimp git gnucash helm homebank htop hydrogen inkscape jdk-openjdk jre-openjdk kubectl latte-dock links lm_sensors lshw lsd lutris mc mysql-workbench nano nfs-utils notepadqq obs-studio openlens-bin openrgb openscad openssh opera pycharm python python-mysqlconnector python-pymysql qbittorrent remmina retroarch rosegarden rpi-imager screenfetch solaar sqlite steam sweethome3d terminator terraform thunar thunderbird tilix todoist virtualbox vlc xterm yay youtube-dl zsh yay paru xsane brother-mfc-l2710dw simple-scan linux-api-headers wine winetricks make patch electron19 python-mysql-connector python-pymysql consola xterm gksu breeze-gtk materia-gtk-theme papirus-icon-theme pop-icon-theme todoist-appimage system-config-printer gnu-netcat');