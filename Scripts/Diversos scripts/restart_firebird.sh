#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/opt/firebird/bin/
DATA=$(date +\%Y-\%m-\%d)
PROCESSID=$(ps -aux | grep /opt/firebird/bin/firebird | grep -v grep | awk '{print $2}')
EMAIL="ssmtp -F"Monitor" -f"monitor@gru.inf.br" -vvv infra@gru.com.br"
BODY="Processo Mensal de Backup e Restore"

#CRIA DIRETORIO DE BACKUP
mkdir /root/backup/$DATA

#STOP FIREBIRD
service firebird-superserver.service stop
PROCESSIDAFTER=$(ps -aux | grep /opt/firebird/bin/firebird | grep -v grep | awk '{print $2}')


#VERIFICA PROCESSO DO FIREBIRD
if [ "${PROCESSIDAFTER}" = "" ] ; then
    echo -e "Subject: [Success] Firebird Windup - Processo $PROCESSID finalizado - `date` \n\nInicio do $BODY" | $EMAIL
else
    echo -e "Subject: [FAILED] Firebird Windup - Processo $PROCESSID não foi finalizado - `date`" | $EMAIL
	exit
fi

#REALIZA BACKUP
gbak -b -user SYSDBA -password masterkey /opt/firebird/banco/DUP2000.FDB /root/backup/$DATA/DUP2000.FBK
STATUSBACKUP=$?

if [ "${STATUSBACKUP}" = "0" ] ; then
    echo -e "Subject: [Success] Backup Windup finalizado - `date` \n\n$BODY" | $EMAIL
else
    echo -e "Subject: [FAILED] Backup Windup não realizado - `date` \n\n$BODY" | $EMAIL
	service firebird-superserver.service start
	exit
fi

#RENOMEIA ARQUIVO DE BANCO ATUAL
mv  /opt/firebird/banco/DUP2000.FDB  /opt/firebird/banco/DUP2000.FDB.OLD.$DATA

#REALIZA RESTORE
gbak -r -v -user SYSDBA -password masterkey /root/backup/$DATA/DUP2000.FBK /opt/firebird/banco/DUP2000.FDB
STATUSRESTORE=$?

if [ "${STATUSRESTORE}" = "0" ] ; then
    echo -e "Subject: [Success] Restore Windup finalizado - `date` \n\n$BODY" | $EMAIL
	chown firebird.firebird /opt/firebird/banco/DUP2000.FDB
	chmod 777 /opt/firebird/banco/DUP2000.FDB
	service firebird-superserver.service start
	PROCESSID=$(ps -aux | grep /opt/firebird/bin/firebird | grep -v grep | awk '{print $2}')
	echo -e "Subject: [Success] Firebird Windup - Processo $PROCESSID iniciado - `date` \n\n$BODY" | $EMAIL
else
    echo -e "Subject: [FAILED] Restore Windup não realizado - `date` \n\n$BODY" | $EMAIL
	mv  /opt/firebird/banco/DUP2000.FDB.OLD.$DATA /opt/firebird/banco/DUP2000.FDB  
	service firebird-superserver.service start
	PROCESSID=$(ps -aux | grep /opt/firebird/bin/firebird | grep -v grep | awk '{print $2}')
	echo -e "Subject: [Success] Firebird Windup - Processo $PROCESSID iniciado - `date` \n\n$BODY" | $EMAIL
fi






