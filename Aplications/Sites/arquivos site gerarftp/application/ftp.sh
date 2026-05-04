#!/bin/bash


IDFTP=$1
SENHA=`head /dev/urandom | tr -dc ABCDEFGHJLMNPQRSTUVXZabcdefghijmnopqrstuvxz23456789 | head -c 8 ; echo ''`

/usr/bin/sudo echo -e "$SENHA\n$SENHA\n \n \n \n \n \nY\n" | /usr/bin/sudo adduser cmatic-sftp-$IDFTP
/usr/bin/sudo echo -e "$SENHA" > /var/www/html/gerarftp/application/kid7ehabayffeay
/usr/bin/sudo echo "cmatic-sftp-$IDFTP" >> /etc/vsftpd.user_list
/usr/bin/sudo mkdir -p /home/cmatic-sftp-$IDFTP/ftp/upload
/usr/bin/sudo chmod 550 /home/cmatic-sftp-$IDFTP/ftp
/usr/bin/sudo chmod 750 /home/cmatic-sftp-$IDFTP/ftp/upload
/usr/bin/sudo chown -R cmatic-sftp-$IDFTP: /home/cmatic-sftp-$IDFTP/ftp
/usr/bin/sudo echo -e "$SENHA\n$SENHA" | /usr/bin/sudo passwd cmatic-sftp-$IDFTP
