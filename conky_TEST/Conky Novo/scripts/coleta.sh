#!/bin/bash

#perl -lne 'BEGIN{undef $/} while (/<div class=\"previsao deg_azul2\">(.*?)<\/div>/sg){print $1}' `curl -s --connect-timeout 30 "http://www.cptec.inpe.br/cidades/tempo/1182"`
#wget `curl -s --connect-timeout 30 "http://www.cptec.inpe.br/cidades/tempo/1182" |sed -n '/<div class="c1">/p' |awk 'NR == 1' |cut -d\> -f3 |cut -d\" -f2` -O /home/juliano/.conkycolors/icons/hoje.png

# Atualiza Hardware
nohup /home/juliano/.conkycolors/scripts/hdw.sh > /home/juliano/.conkycolors/scripts/dados.txt

#/Imagem Previsao
wget `curl -s --connect-timeout 30 "http://servicos.cptec.inpe.br/RSS/cidade/1182/previsao.xml" |grep "img src=" |cut -d\" -f2` -O /home/juliano/.conkycolors/icons/hoje.gif

#Texto Previsao
echo `curl -s --connect-timeout 30 "http://www.cptec.inpe.br/cidades/tempo/1182" |sed -n '/<div class="c8">/p' |awk 'NR == 1' |cut -d\> -f2 |cut -d\< -f1` >> /home/juliano/.conkycolors/scripts/dados.txt

#Temperatura
echo `curl -s --connect-timeout 30 "http://www.cptec.inpe.br/cidades/tempo/1182" |sed -n '/ TEMPERATURA ATUAL/p' |cut -d\> -f5 |cut -d\< -f1` >> /home/juliano/.conkycolors/scripts/dados.txt

#Minima
echo `curl -s --connect-timeout 30 "http://servicos.cptec.inpe.br/RSS/cidade/1182/previsao.xml" |awk 'NR == 20 {print $6}'` >> /home/juliano/.conkycolors/scripts/dados.txt

#Maxima
echo `curl -s --connect-timeout 30 "http://servicos.cptec.inpe.br/RSS/cidade/1182/previsao.xml" |awk 'NR == 20 {print $8}'` >> /home/juliano/.conkycolors/scripts/dados.txt

#Umidade
echo `curl -s --connect-timeout 30 "http://www.cptec.inpe.br/cidades/tempo/1182" |sed -n '/ UMIDADE RELATIVA /p' |cut -d\> -f5 |cut -d\< -f1` >> /home/juliano/.conkycolors/scripts/dados.txt

#Pressao
echo `curl -s --connect-timeout 30 "http://www.cptec.inpe.br/cidades/tempo/1182" |sed -n '/PRESS&Atilde;O ATMOSF&Eacute;RICA&nbsp;*/p' |cut -d\> -f5 |cut -d\< -f1` >> /home/juliano/.conkycolors/scripts/dados.txt

#Vento
echo `curl -s --connect-timeout 30 "http://www.cptec.inpe.br/cidades/tempo/1182" |sed -n '/DIR. E INTENSIDADE/p' |cut -d\> -f7 |cut -d\" -f1 |cut -d\< -f1` >> /home/juliano/.conkycolors/scripts/dados.txt
