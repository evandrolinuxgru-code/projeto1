#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
DATA=$(date '+%d-%m-%Y')
cd /Backup_Repository_6/sistemas/
mkdir BACKUP-$DATA
FOLDER=/Backup_Repository_6/sistemas/BACKUP-$DATA

#APAGA PASTAS ANTIGAS
cd /Backup_Repository_6/sistemas/
find . -maxdepth 1 -type d -mtime +5 | xargs rm -rf

#BACKUP DIRETORIOS
ssh 192.168.5.220 -p 2222 'tar -cf - /etc/ | gzip -1' > $FOLDER/etc-$DATA.tar.gz
ssh 192.168.5.220 -p 2222 'tar -cf - /home/ | gzip -1' > $FOLDER/home-$DATA.tar.gz
ssh 192.168.5.220 -p 2222 'tar -cf - /opt/ | gzip -1' > $FOLDER/opt-$DATA.tar.gz
ssh 192.168.5.220 -p 2222 'tar -cf - /usr/local/ | gzip -1' > $FOLDER/usrlocal-$DATA.tar.gz
ssh 192.168.5.220 -p 2222 'tar -cf - /usr/share/jenkins/ | gzip -1' > $FOLDER/usrsharejenkins-$DATA.tar.gz
ssh 192.168.5.220 -p 2222 'tar -cf - /var/lib/jenkins/ | gzip -1' > $FOLDER/varlibjenkins-$DATA.tar.gz

#BACKUP BANCOS
ssh 192.168.5.220 -p 2222 'cd /var/lib/postgresql && sudo -u postgres pg_dumpall -p 59595 | gzip -1' > $FOLDER/CONTSHDSV02-postgres-$DATA.tar.gz
ssh 192.168.5.220 -p 2222 'mysqldump -uroot -pcqepvc --opt -a -v --max_allowed_packet 2G --single-transaction --all-databases | gzip -1' > $FOLDER/CONTSHDSV02-mysql-$DATA.tar.gz






