#!/bin/bash
sensors |grep "MB" |cut -c 21-27
sensors |grep "Vcore Voltage" |cut -c 20-26
sensors |grep "+3.3 Voltage" |cut -c 20-26
sensors |grep "+5 Voltage" |cut -c 20-26
sensors |grep "+12 Voltage" |cut -c 20-26
