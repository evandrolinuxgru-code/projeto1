#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin

systemctl show tomcat-gestao | grep 'Names\|ActiveEnterTimestamp=\|^MainPID\|SubState' > OLDSERVICE

systemctl restart tomcat-gestao
result=$?

systemctl show tomcat-gestao | grep 'Names\|ActiveEnterTimestamp=\|^MainPID\|SubState' > NEWSERVICE

if [ "${result}" -eq "0" ] ; then
	echo -e "Subject: Processo tomcat gestao finalizado - `date`\n\n`cat OLDSERVICE`" | ssmtp -vvv infra@contmatic.com.br,victor.silva@contmatic.com.br,kelton.ribeiro@contmatic.com.br
	echo -e "Subject: Processo tomcat gestao iniciado - `date`\n\n`cat NEWSERVICE`" | ssmtp -vvv infra@contmatic.com.br,victor.silva@contmatic.com.br,kelton.ribeiro@contmatic.com.br
else
	echo -e "Subject: Processo do Gestao não foi reiniciado - `date`" | ssmtp -vvv evandro@contmatic.com.br
fi
