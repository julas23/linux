#!/bin/bash
RAM1=`dmidecode -t memory |grep "Type:" |awk $1 'NR == 2 {print $2}'`
RAM2=`dmidecode -t memory |grep "Size:" |awk '{print $2,$3}'`
RAM3=`dmidecode -t memory |grep "Locator:" |awk 'NR == 1 {print $2}'`
MOBO=`dmidecode -t baseboard |grep Product |cut -c 16-30`
CPU=`dmidecode --string=processor-version | tail -n1 |cut -c 1-27`
VGA1=`lspci | grep VGA |awk '{print $5,$6}'`
VGA2=`lsmod |grep "video " |awk 'NR == 2 {print $4}'`
TYPE=`dmidecode -t chassis |grep "Type:" |awk '{print $2}'`
MANU=`dmidecode -t chassis |grep "Manuf" |awk '{print $2}'`
MODE=`dmidecode -t baseboard |grep "Product Name:" |awk '{print $3}'`
SERI=`dmidecode -t system |grep "Product Name:" |awk '{print $3}'`
HDD1=`hdparm -i /dev/sda |grep "Model=" |cut -c 8-14`
HDD2=`fdisk -l /dev/sda |awk 'NR == 2' |cut -c 17-24`
HDD3=`smartctl -a /dev/sda |grep Rotation |awk '{print $3,$4,$5}'`

echo "$TYPE $MANU $MODE $SERI"
echo "$CPU"
echo "$VGA1 $VGA2"
echo "$RAM2 $RAM3 $RAM1"
echo "$HDD3 $HDD2"

exit 0
