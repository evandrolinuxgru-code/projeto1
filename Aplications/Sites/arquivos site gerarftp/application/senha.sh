#!/bin/bash


IDFTP=$1
SENHA=`head /dev/urandom | tr -dc ABCDEFGHJLMNPQRSTUVXZabcdefghijmnopqrstuvxz23456789 | head -c 8 ; echo ''`

/usr/bin/sudo echo -e "$SENHA" > /var/www/html/gerarftp/application/kid7ehabayffeay
/usr/bin/sudo echo -e "$SENHA\n$SENHA" | /usr/bin/sudo passwd cmatic-sftp-$IDFTP
