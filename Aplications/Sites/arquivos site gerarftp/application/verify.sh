#!/bin/bash


IDFTP=$1
/usr/bin/sudo grep -w cmatic-sftp-$IDFTP /etc/passwd && result=0

if [ "${result}" -eq "0" ] ; then
/usr/bin/sudo echo $IDFTP > /var/www/html/gerarftp/application/usuario
else
/usr/bin/sudo echo "SFTP não existente" > /var/www/html/gerarftp/application/usuario

fi

