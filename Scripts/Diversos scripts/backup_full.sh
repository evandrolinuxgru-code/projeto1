#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
DATA=$(date '+%d-%m-%Y')
SERVER=COBDM02
MINIMUMSIZE=1100000000
BACKUP=/root/backup/contspbdm02-"$DATA".tar.gz

rm -rf /root/backup/full/*
rm -rf /root/backup/contdm02-*

sudo xtrabackup --user=root  --password=cqepvc --backup  --compress --target-dir=/root/backup/full/

tar -czvf /root/backup/contspbdm02-"$DATA".tar.gz /root/backup/full/

ACTUALSIZE=$(wc -c < $BACKUP)

scp /root/backup/contspbdm02-"$DATA".tar.gz root@192.168.99.12:/backup/banco/contspbdm02/

if [ $ACTUALSIZE -ge $MINIMUMSIZE ] ; then
 echo  -e "Subject: [Success] Backup Banco $SERVER - $(date +'%Y-%m-%d')\n\nDetalhes:\n`ls -l $BACKUP`\n`du -sh $BACKUP`" | ssmtp -vvv -F"Backup" -f"backup@gru.inf.br" infra@gru.com.br
else
 echo  -e "Subject: [Failed] Backup Banco $SERVER - $(date +'%Y-%m-%d')" | ssmtp -vvv -F"Backup" -f"backup@gru.inf.br" infra@gru.com.br
fi
