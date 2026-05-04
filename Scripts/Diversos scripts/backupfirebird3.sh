# !/bin/sh

  DIA=$(date +%Y%m%d)
  GB='/opt/firebird/bin/gbak'
  GF='/opt/firebird/bin/gfix'
  US='sysdba'
  PW='masterkey'
  PH='/opt/firebird/banco'
  DB='DUP2000.FDB'
  BK='/backup/'
  LOG=$BK/$DIA'-bkfb.log'

  #Variaveis para envio de email
  SERVER=CONTSPBDM05
  MINIMUMSIZE=1100000000
  BACKUP=$BK$DIA/$DIA-base.tar.gz
  
  # Cria diretorio diario do backup da base de dados
  echo 'Criando diretorio para o backup' >> $LOG
  mkdir $BK/$DIA
  echo 'Diretorio criado :  ' >> $LOG
  ls -la -ad $BK/$DIA >> $LOG
  echo 'Diretorio criado com sucesso!' >> $LOG && echo ' ' >> $LOG

  # Shutdown na Base de Dados
  echo 'Efetuando shutdown na base de dados' >> $LOG
  $GF -z >> $LOG 2>&1
  $GF -shut -force 0 -user $US -password $PW $PH/$DB >> $LOG 2>&1
  echo 'A Base de dados agora estÃ¡ OFFLINE...' >> $LOG && echo ' ' >> $LOG

  #
  # Copia a base de dados
  #
  echo 'Copiando a base de dados ' >> $LOG  && echo ' ' >> $LOG
  cp $PH/$DB $BK/$DIA/$DIA-base.fdb
  ls -la $BK/$DIA/$DIA-base.fdb >> $LOG && echo ' ' >> $LOG
  echo 'Base de dados copiada com sucesso!' >> $LOG
  echo 'Uma copia da base, por seguranca estah no diretorio'$BK/$DIA >> $LOG && echo ' ' >> $LOG

  echo 'Compactando o backup da base de dados...' >> $LOG
  tar -czvf $BK/$DIA/$DIA-base.tar.gz $BK/$DIA/$DIA-base.fdb >> $LOG 2>&1
  ls -la $BK/$DIA/$DIA-base.tar.gz >> $LOG && echo ' ' >> $LOG
  echo 'O backup da base de dados foi compactado com sucesso!' >> $LOG && echo ' ' >> $LOG

  chown firebird:firebird $PH/$DB
  echo 'Mudanca de proprietario e grupo FIREBIRD efetuada com sucesso!' >> $LOG && echo ' ' >> $LOG

  echo 'Aplicando permissao total 777 ao arquivo da base' >> $LOG
  chmod 777 $PH/$DB >> $LOG 2>&1
  echo 'Permissao aplicada com sucesso!' >> $LOG && echo ' ' >> $LOG


  #
  # Volta a base de dados para o estado ONLINE
  #
  echo 'Voltando a base de dados para o estado ONLINE' >> $LOG
  $GF -online -user $US -password $PW $PH/$DB >> $LOG 2>&1  && echo ' ' >> $LOG
  echo 'Base ONLINE!' >> $LOG && echo ' ' >> $LOG


  echo -n 'Data: ' >> $LOG && date +%d/%m/%Y-%H:%M:%S >> $LOG
  echo '*** Fim do backup diario ***' >> $LOG  && echo ' ' >> $LOG

  #
  # Coloca mensagem no console avisando sobre o final, mostrando
  # data e hora novamente.
  echo ' '
  echo -n 'Processo de backup finalizado com sucesso em: ' && date +%d/%m/%Y' - as '%H:%M
  echo ' '

# COPIA PARA SERVIDOR DE BACKUP

mkdir -p /media/CONTSPBDM05/windup/$DIA

cp $BK/$DIA/$DIA-* /media/CONTSPBDM05/windup/$DIA/

## alterado por Wagner Corrêa
scp /media/CONTSPBDM05/windup/$DIA/* 192.168.99.12:/backup/banco/contspbdm05/
echo '*** Arquivo transferido para o servidor 192.168.99.12  ***' >> $LOG  && echo ' ' >> $LOG


##excluir backups de mais de 5 dias

find $BK/ -maxdepth 1 -type f -mtime +3 | xargs rm -rvf
find $BK/ -type d -ctime +3 -exec rm -rf {} \;
find /media/CONTSPBDM05/windup/ -type d -mtime +3 -exec rm -rf {} \;

#Email de backup
ACTUALSIZE=$(wc -c < $BACKUP)

if [ $ACTUALSIZE -ge $MINIMUMSIZE ] ; then
 echo  -e "Subject: [Success] Backup Banco $SERVER - $(date +'%Y-%m-%d')\n\nDetalhes:\n`ls -l $BACKUP`\n`du -sh $BACKUP`" | /usr/sbin/ssmtp -vvv -F"Backup" -f"backup@gru.inf.br" infra@gru.com.br
else
 echo  -e "Subject: [Failed] Backup Banco $SERVER - $(date +'%Y-%m-%d')" | /usr/sbin/ssmtp -vvv -F"Backup" -f"backup@gru.inf.br" infra@gru.com.br
fi


