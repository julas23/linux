CREATE DATABASE IF NOT EXISTS monitor;
USE monitor;

DROP TABLE IF EXISTS t_infra;
DROP TABLE IF EXISTS t_cmmnd;
DROP TABLE IF EXISTS t_outpt;
DROP TABLE IF EXISTS t_reslt;

CREATE TABLE IF NOT EXISTS t_infra (
    inf_id INT PRIMARY KEY,
    inf_rng TEXT,
    inf_nmk TEXT,
    inf_rpi TEXT,
    inf_pcr TEXT,
    inf_ssh TEXT,
    UNIQUE(inf_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_cmmnd (
    cmd_id INT PRIMARY KEY,
    cmd_var TEXT,
    cmd_run TEXT,
    cmd_det TEXT,
    UNIQUE(cmd_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_outpt (
    out_id INT PRIMARY KEY,
    out_var TEXT,
    out_blk TEXT,
    out_det TEXT,
    UNIQUE(out_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_reslt (
    res_id INT PRIMARY KEY,
    res_var TEXT,
    res_run TEXT,
    res_det TEXT,
    UNIQUE(res_id)
) ENGINE=InnoDB;