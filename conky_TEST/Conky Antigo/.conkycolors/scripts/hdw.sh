#!/bin/bash
RAM1=`dmidecode -t memory |grep "Speed:" | awk $1 'NR == 1 {print $2,$3}'`
RAM2=`grep MemTotal /proc/meminfo |cut -c 18-27`
MOBO=`dmidecode -t baseboard |grep Product |cut -c 16-30`
CPU=`dmidecode --string=processor-version | tail -n1 |cut -c 1-27`
VGA=`aticonfig --list-adapters |grep Series |cut -c 14-31`

echo "Placa-Mae: $MOBO"
echo "Processador: $CPU"
echo "Video: $VGA"
echo "Memoria: $RAM2 $RAM1"



