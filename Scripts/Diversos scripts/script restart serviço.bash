#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
PROCESSID=$(ps -aux | grep tomcat | grep reports | awk '{print $2}')

#Executar processo para matar serviço
/gestao/app/tomcat-reports/bin/shutdown.sh

#Kill nos processos com nome tomcat e reports
kill -9 $PROCESSID

#Filtro para verificar se ainda há processos tomcat e reports
ps aux | grep -v grep | grep tomcat | grep reports > /dev/null

#Se result do filtro = 1 matou processo , senão processo está ativo
result=$?

if [ "${result}" -eq "1" ] ; then
        echo "Subject: Processo tomcat reports $PROCESSID finalizado - `date`" | ssmtp -vvv infra@contmatic.com.br,victor.silva@contmatic.com.br
        sleep 10
        cd /gestao/app/tomcat-reports/bin
		./startup.sh
        export PROCESSIDNEW=$(ps -aux | grep tomcat | grep reports | awk '{print $2}')
        echo "Subject: Processo tomcat reports $PROCESSIDNEW iniciado - `date`" | ssmtp -vvv infra@contmatic.com.br,victor.silva@contmatic.com.br
else
        echo "Subject: Processo do reports não foi reiniciado - `date`" | ssmtp -vvv infra@contmatic.com.br,victor.silva@contmatic.com.br
fi
