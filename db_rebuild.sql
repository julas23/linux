CREATE DATABASE IF NOT EXISTS conky;
USE conky;

DROP TABLE IF EXISTS t_results;
DROP TABLE IF EXISTS t_bulkcon;

CREATE TABLE IF NOT EXISTS t_results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    variable TEXT,
    descr TEXT,
    outpu TEXT,
    UNIQUE(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_bulkcon (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cmd_out TEXT,
    mass_out TEXT,
    UNIQUE(id)
) ENGINE=InnoDB;

INSERT INTO t_results (variable, descr, outpu) VALUES
('chk_users_log', 'Count how many users are logged in and who they are', ''),
('distroversion', 'Inform the distribution and version of Linux', ''),
('kernelversion', 'Grab the kernel version, compilation, and architecture', ''),
('shell_running', 'Shows what shell is currently running', ''),
('x11resolution', 'Stamp the current resolution of monitor(s)', ''),
('graphic_envin', 'Will inform about the graphical environment running', ''),
('envinrmanager', 'What kind of graphical environment is currently in use', ''),
('envinrontheme', 'The theme that is currently in use for the environment', ''),
('cpu_manufectu', 'The manufacturer of the CPU', ''),
('cpu_temperatu', 'The temperature of the CPU', ''),
('gpu_manufactu', 'Manufacturer of GPU', ''),
('gpu_temperatu', 'Temperature of GPU', ''),
('mobo_manufact', 'Motherboard Manufacturer', ''),
('mobo_modelver', 'Motherboard Model and Version', ''),
('mobo_ddr_slot', 'Quantity of DDR slots', ''),
('mobo_ddr_used', 'How many DDR slots are in use', ''),
('mobo_ddr_size', 'Total size of DDR', ''),
('mobo_ddr_alls', 'Total available slots in MoBo', ''),
('mobo_temperat', 'Motherboard temperature', ''),
('fan1_rpm_spee', 'System Fan RPM', ''),
('case_temperat', 'Case Temperature', ''),
('case_fan_rpms', 'Case Fan RPM', ''),
('memory_cloksp', 'Memory Clock Speed', ''),
('memory_slotty', 'Memory Slot Type', ''),
('public_ip_add', 'Public IP', ''),
('weather_tmp_n', 'Weather temperature now', ''),
('weather_tmp_m', 'Weather temperature minimum', ''),
('weather_tmp_x', 'Weather temperature maximum', ''),
('nvme0_tempera', 'nvme0 temperature', ''),
('nvme1_tempera', 'nvme1 temperature', ''),
('nvme2_tempera', 'nvme2 temperature', ''),
('next_1_day_fw', 'Date 1 day ago', ''),
('next_2_day_fw', 'Date 2 days ago', ''),
('next_3_day_fw', 'Date 3 days ago', ''),
('next_4_day_fw', 'Date 4 days ago', '');

INSERT INTO t_bulkcon (cmd_out, mass_out) VALUES
('neofetch --off', ''),
('sudo lshw -class memory', ''),
('sensors', ''),
('sudo dmidecode -t 2', ''),
('sudo dmidecode -t 17', ''),
('nvidia-smi', ''),
('data-update', '');