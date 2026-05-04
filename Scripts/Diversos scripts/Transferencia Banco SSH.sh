#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
cd /backup
SERVER=
SOURCEBACKUP=$(date --date "-1 days" +'%Y-%m-%d')
DESTINATIONBACKUP=/backup/google/gestao
DAYOFWEEK=`date +%w`
SATURDAY=6

#Verifica se é sabado para realizar transferencia
if [ "${DAYOFWEEK}" -eq "${SATURDAY}" ] ; then
	echo OK 
else
	exit
fi

#Remove backups anteriores
ssh 201.63.226.4  "cd $DESTINATIONBACKUP; rm -rf *.tar.gz"
ssh 177.92.74.218 "cd $DESTINATIONBACKUP; rm -rf *.tar.gz"

#Inicia transferencia de backup
tar zcf - $SOURCEBACKUP | ssh 201.63.226.4 "cat > $DESTINATIONBACKUP/$SOURCEBACKUP.tar.gz"
STATUSTRANSFERENCIA=$?

#verifica se transferencia foi executada, em caso de erro executa transferencia na segunda operadora
if [ "${STATUSTRANSFERENCIA}" -eq "0" ] ; then
	echo -e "Subject: [Success] Backup Banco $SERVER - $(date +'%Y-%m-%d') - Transferencia\n\nTransferencia de Backup realizado para Contmatic" | ssmtp -vvv -F"Backup" -f"backup@gru.inf.br" infra@gru.com.br
else
	tar zcf - $SOURCEBACKUP | ssh 177.92.74.218 "cat > $DESTINATIONBACKUP/$SOURCEBACKUP.tar.gz"
	STATUSTRANSFERENCIA2=$?
		if [ "${STATUSTRANSFERENCIA2}" -eq "0" ] ; then
			echo  -e "Subject: [Success] Backup Banco $SERVER - $(date +'%Y-%m-%d') - Transferencia\n\nTransferencia de Backup realizado para Contmatic" | ssmtp -vvv -F"Backup" -f"backup@gru.inf.br" infra@gru.com.br
		else
			echo  -e "Subject: [Failed] Backup Banco $SERVER - $(date +'%Y-%m-%d') - Transferencia" | ssmtp -vvv -F"Backup" -f"backup@gru.inf.br" infra@gru.com.br
		fi
fi

