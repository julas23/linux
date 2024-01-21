DROP DATABASE IF EXISTS monitor;

CREATE DATABASE IF NOT EXISTS monitor;
USE monitor;

DROP TABLE IF EXISTS t_infra;
DROP TABLE IF EXISTS t_outpt;
DROP TABLE IF EXISTS t_todo;
DROP TABLE IF EXISTS t_safe;

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
    cmd_run TEXT,
    cmd_out TEXT,
    UNIQUE(cmd_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_outpt (
    out_id INT PRIMARY KEY,
    out_cmd TEXT,
    out_var TEXT,
    out_blk TEXT,
    out_det TEXT,
    UNIQUE(out_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_todo (
    tod_id INT PRIMARY KEY,
    tod_typ TEXT CHECK (tod_typ IN ('note', 'task')),
    tod_tex TEXT,
    ok BIT,
    UNIQUE(tod_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_safe (
    var_id INT PRIMARY KEY,
    var_nam TEXT,
    var_val TEXT,
    UNIQUE (var_nam)
) ENGINE=InnoDB;