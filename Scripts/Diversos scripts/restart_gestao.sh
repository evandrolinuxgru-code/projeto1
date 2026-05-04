!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
PROCESSID=$(ps -aux | grep tomcat | grep gestao | awk '{print $2}')

cd /gestao/app
./stopAll.sh

#Kill nos processos com nome tomcat e gestao
kill -9 $PROCESSID

#Filtro para verificar se ainda há processos tomcat e gestao
ps aux | grep -v grep | grep tomcat | grep gestao > /dev/null

#Se result do filtro = 1 matou processo , senão processo está tivo
result=$?

if [ "${result}" -eq "1" ] ; then
	echo "Subject: Processo tomcat gestao $PROCESSID finalizado - `date`" | ssmtp -vvv infra@contmatic.com.br
	sleep 10
	./startAll-01.sh
	export PROCESSIDNEW=$(ps -aux | grep tomcat | grep gestao | awk '{print $2}')
	echo "Subject: Processo tomcat gestao $PROCESSIDNEW iniciado - `date`" | ssmtp -vvv infra@contmatic.com.br

else
    echo "Subject: Processo do Gestao não foi reiniciado - `date`" | ssmtp -vvv infra@contmatic.com.br
fi
