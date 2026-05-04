app.contmatictransportes.com.br

ATENÇÃO: Se o servidor for derrubado e algum cliente estiver emitindo nota essa nota será enviada mas não terá retorno e não existe possibilidade de recuperar a nota. 

Executar o bloqueio de emissão: 

##mysql -utransporte -pTransp@2019@! svs_web -hCONTSPTRS02 -e "update bloqueio_sistema set bloqueado=1"

Após executar o comando e aguardar 10 minutos para os processos finalizarem.

Verificar o log de tarifação se está exatamente igual ao log abaixo (vazio):
26/10 02:15:16  INFO [SendBillingRecord] [Tarifacao] Iniciando tarifacao ... 
26/10 02:15:16  INFO [SendBillingRecord] [Tarifacao] Fim tarifacao 

Verificado o log derrubar o servidor.
##tail -f /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out


Se estiver no ar derrubar com o kill -9 PID

##ps -edfa|grep -i 'transportes/app/jdk1.8.0_161'|grep -v grep

Efetuar backup do banco de dados: mysqldump -utransporte -pTransp@2019@! svs_web -hCONTSPTRS02  > /home/transportes/backup/svs_web.sql

##mysqldump --single-transaction -utransporte -pTransp@2019@! svs_web -hCONTSPTRS02  > /home/transportes/backup/svs_web.sql
mysqldump --single-transaction --max_allowed_packet=1024M -utransporte -pTransp@2019@! svs_web -hCONTSPTRS02  > /home/transportes/backup/svs_web.sql 

copia de nav.war em /transporte/app/backup
remover nav.war e nav de webapps


##cd /transportes/app/transportes/apache-tomcat-8.5.27/webapps/
##rm -rf nav*

Copiar o arquivo NAV : cp nav.war /home/transportes/app/transportes/webapps/
##cp /transportes/app/deploy/nav.war /transportes/app/transportes/apache-tomcat-8.5.27/webapps

Entrar no diretório: cd /home/transportes/app/transportes/bin
Para iniciar efetuar o seguinte comando: ./startup.sh
##/transportes/app/transportes/apache-tomcat-8.5.27/bin/startup.sh

Executar o script sql atualizacaoVersao2_11.sql

##mysql -utransporte  -pTransp@2019@! svs_web  -hCONTSPTRS02 < /transportes/app/atualizacaoVersao2_11.sql

Após os testes desbloquear o sistema: mysql -utransporte  -pTransp@2019@! svs_web  -hCONTSPTRS02 -e "update bloqueio_sistema set bloqueado=0"

mysql -utransporte  -pTransp@2019@! svs_web  -hCONTSPTRS02 -e "update bloqueio_sistema set bloqueado=0"
mysql -utransporte  -pTransp@2019@! svs_web  -hCONTSPTRS02 -e "update manutencao_sistema set manutencao=0"
mysql -utransporte  -pTransp@2019@! svs_web  -hCONTSPTRS02 -e "update manutencao_sistema set manutencao=1"
##mysql -utransporte  -pTransp@2019@! svs_web  -hCONTSPTRS02 -e "update bloqueio_sistema set bloqueado=0"




####HISTORY INFRA (ANTES DA MUDANÇA)
    1  yum update -y
    2  sudo su
    3  vim /etc/selinux/config
    4  sudo su
    5  su -
    6  sudo su
    7  vim /etc/security/limits.conf
    8  sudo su -
    9  htop
   10  sudo su
   11  history
   12  sudo su
   13  yum list|grep zabbix
   14  yum list|grep zabbix|grep agent
   15  yum install zabbix30-agent.x86_64
   16  sudo yum install zabbix30-agent.x86_64
   17  vi /etc/zabbix/zabbix_agentd.conf
   18  sudo vi /etc/zabbix/zabbix_agentd.conf
   19  sudo systemctl enable zabbix-agent
   20  sudo systemctl start zabbix-agent
   21  sudo vi /etc/zabbix/zabbix_agentd.conf
   22  telnet mailserver.contmatic.com.br 587
   23  Oct 14 18:04:40 contspmail01 sendmail[1131]: STARTTLS=client, error: SSL_CTX_check_private_key failed(/etc/mail/cert/server.crt): 0
   24  Oct 14 18:04:40 contspmail01 sendmail[1131]: STARTTLS=client, relay=mx.core.locaweb.com.br., version=TLSv1/SSLv3, verify=FAIL, cipher=DHE-RSA-AES256-SHA, bits=256/256
   25  Oct 14 18:04:40 contspmail01 sendmail[1131]: x9EL4XLo001111: to=<francine.campos@starsonic.com.br>, ctladdr=<crislene.maia@contmatic.com.br> (960/100), delay=00:00:05, xdelay=00:00:01, mailer=esmtp, pri=402603, relay=mx.core.locaweb.com.br. [177.153.23.241], dsn=2.0.0, stat=Sent (Ok: queued as 46sWK42Z5gz1F)
   26  Oct 14 18:04:42 contspmail01 sendmail[1132]: x9EL4Kck001075: to=<ricardo_sjcampos@contmatic.com.br>, delay=00:00:02, xdelay=00:00:02, mailer=local, pri=195426, dsn=2.0.0, stat=Sent
   27  Oct 14 18:04:46 contspmail01 sendmail[868]: x9EL2TuO000868: 154.119.229.35.bc.googleusercontent.com [35.229.119.154]: possible SMTP attack: command=HELO/EHLO, count=3
   28  Oct 14 18:04:47 contspmail01 sendmail[868]: x9EL2TuP000868: from=teste@contmatic.com.br, size=7, class=0, nrcpts=1, msgid=<201910142104.x9EL2TuP000868@contmatic.com.br>, proto=SMTP, daemon=MSA, relay=154.119.229.35.bc.googleusercontent.com [35.229.119.154]
   29  Oct 14 18:04:47 contspmail01 sendmail[1143]: x9EL2TuP000868: to=moises.magalhaes@contmatic.com.br, delay=00:00:00, xdelay=00:00:00, mailer=local, pri=30357, dsn=2.0.0, stat=Sent
   30  telnet mailserver.contmatic.com.br 587
   31  sudo vi /etc/zabbix/zabbix_agentd.conf
   32  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   33  sudo mkdir /etc/zabbix/zabbix_agentd.d
   34  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   35  systemctl stop zabbix-agent
   36  sudo systemctl stop zabbix-agent
   37  sudo systemctl start zabbix-agent
   38  sudo systemctl sp zabbix-agent
   39  sudo systemctl status zabbix-agent
   40  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   41  ps -edfa|grep -i "jdk1.8.0_161"|grep -v grep | awk '{print $2}'
   42  ps -edfa|grep -i "jdk1."|grep -v grep | awk '{print $2}'
   43  ps ax|grep trans
   44  ps ax|grep bil
   45  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   46  ps -edfa|grep -i "jdk1.6.0_45"|grep -v grep | awk '{print $2}'
   47  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   48  ps ax|grep trans
   49  ps ax|grep tomcat
   50  :q
   51  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   52  ps -edfa|grep -i "jdk1.6.0_45"|grep -i billing | grep -v grep | awk '{print $2}'
   53  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   54  ps -edfa|grep -i "jdk1.8.0_161"|grep -v grep | awk '{print $2}'
   55  :q
   56  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   57  ps -edfa|grep -i "jdk1.8.0_221"|grep -v grep | awk '{print $2}'
   58  sudo vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   59  sudo systemctl stop zabbix-agent
   60  sudo systemctl start zabbix-agent
   61  sudo systemctl status zabbix-agent
   62  sysctl -a|grep clos
   63  sudo sysctl -a|grep clos
   64  iptables -L
   65  sudo iptables -L
   66  sudo sysctl -a|grep keep
   67  ss -n4t | head
   68  netsat
   69  netstat -n
   70  ss
   71  ss |grep 8083
   72  netstat -n
   73  ss |grep 8083
   74  ss -n|grep 8083
   75  ss -n4|grep 8083
   76  ss -nt|grep 8083
   77  sudo sysctl -a|grep tcp_fin
   78  lsof |grep 8083
   79  lsof
   80  sudo lsof |grep 8083
   81  sudo lsof
   82  sudo lsof -i:8083
   83  sudo ps aux|grep 8782
   84  sudo sysctl -a|grep tcp_fin
   85  sudo sysctl -a|grep keep
   86  netstat -n|grep 8083
   87  netstat -n|grep 127
   88  vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   89  ps -edfa|grep -i "jdk1.6.0_45"|grep -i billing | grep -v grep | awk '{print $2}'
   90  ps aux|grep jdk
   91  exit
   92  vi /etc/zabbix/zabbix_agentd.d/userparams.conf
   93  cd
   94  6
   95  "
   96  ?7*@6!
   97  cd
   98  6
   99  "
  100  ?7*@6!
  101  6
  102  
  103  sudo su - transportes
  104  exit
  105  sudo su
  106  sudo su -
  107  sudo su
  108  sudo lsof -i:8083
  109  w
  110  sudo ps aux|grep java
  111  sudo ps aux|grep jdk
  112  vi /etc/zabbix/zabbix_agentd.d/userparams.conf
  113  sudo ps aux|grep jdk
  114  uptime
  115  vi /home/infra/.viminfo
  116  exit
  117  ps aux|grep java
  118  sudo su transportes
  119  sudo setcap cap_net_bind_service+ep /transportes/app/jdk1.8.0_161/bin/java
  120  sudo ln -s /transportes/app/jdk1.8.0_161/lib/amd64/jli/libjli.so /usr/lib/
  121  ls -lha /usr/lib/libjli.so
  122  rm -rf /usr/lib/libjli.so
  123  sudo rm -rf /usr/lib/libjli.so
  124  sudo ln -s /transportes/app/jdk1.8.0_161/lib/amd64/jli/libjli.so /usr/lib/
  125  ls -lha /usr/lib/libjli.so
  126  sudo vim /etc/ld.so.conf.d/java.conf
  127  sudo ldconfig
  128  cd /transportes/app/jdk1.8.0_161
  129  cd bin/
  130  java -version
  131  ./java -version
  132  cd /transportes/app/transportes/apache-tomcat-8.5.27/logs/
  133  tail -f catalina.out
  134  sudo tail -f catalina.out
  135  mysql -utransporte -pTransp@2019@! svs_web -h CONTSPTRS02 -e "update bloqueio_sistema set bloqueado=1"
  136  cd  ..
  137  cd bin/
  138  cd ..
  139  ls
  140  cd ..
  141  ls
  142  cd billing/
  143  ls
  144  cd bin/
  145  ls
  146  mysql -utransporte -pTransp@2019@! svs_web -h CONTSPTRS02 -e "update bloqueio_sistema set bloqueado=0"
  147  sudo su transprtes
  148  sudo su transportes
  149  netstat -na|grep 8083|grep "CLOSE_WAIT"|wc -l
  150  lsof -i|grep 8083
  151  lsof -i:8083
  152  netstat -na|grep 8083|grep "CLOSE_WAIT"|wc -l
  153  date
  154  clear
  155  date
  156  mysql -utransporte -p svs_web -h CONTSPTRS02 -e "update bloqueio_sistema set bloqueado=1"
  157  mysql -udaniel.nery -p svs_web -h CONTSPTRS02 -e "update bloqueio_sistema set bloqueado=1"
  158  clear
  159  date
  160  CLEAR
  161  ckear
  162  clear
  163  date
  164  mysql -utransporte -p svs_web -h CONTSPTRS02 -e "update bloqueio_sistema set bloqueado=1"
  165  tail -f /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out
  166  sudo tail -f /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out
  167  clear
  168  sudo tail -f /transportes/app/billing-send/nohup.out
  169  sudo su transportes
  170  sudo tail -f /transportes/app/billing-send/nohup.out
  171  sudo tail -f /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out
  172  sudo cat -f /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out |grep ERR
  173  sudo cat /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out |grep ERR
  174  sudo cat /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out |grep ERR|grep for
  175  sudo cat /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out |grep ERR|grep forei
  176  sudo cat /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out |grep Schema
  177  sudo cat /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out |grep SchemaUpdate
  178  sudo cat /transportes/app/transportes/apache-tomcat-8.5.27/logs/catalina.out |grep SchemaUpdate|grep id_cer
  179  exit
  180  su transportes
  181  netstat -nat | grep CLOSE_WAIT| wc -l
  182  netstat -nap|grep 8083|wc -l
  183  netstat -nat | grep CLOSE_WAIT| wc -l
  184  netstat -nap|grep 8083
  185  netstat -nat | grep CLOSE_WAIT| wc -l
  186  netstat -nap|grep 8083|wc -l
  187  netstat -nat | grep CLOSE_WAIT| wc -l
  188  lsof -i:8083
  189  netstat -nat | grep CLOSE_WAIT| wc -l
  190  su transportes
  191  sudo su
  192  w
  193  sudo su transportes
  194  sudo su
  195  ll
  196  clear
  197  date
  198  mysql -utransporte  -p svs_web -h CONTSPTRS02 -e "update bloqueio_sistema set bloqueado=1"
  199  cd /transportes/app/transportes/apache-tomcat-8.5.27/logs/
  200  tail -f catalina.out
  201  sudo su transporte
  202  sudo su transportes
  203  ls
  204  cd /home/infra/
  205  ls
  206  cd deploy/
  207  cd 14012020/
  208  ls
  209  cd ..
  210  ls
  211  cd 14012020/
  212  ls
  213  ll
  214  cd ..
  215  ll
  216  mv atualizacaoVersao2_09.sql 14012020/
  217  mv nav.war 14012020/
  218  cd 14012020/
  219  ls
  220  cat atualizacaoVersao2_09.sql
  221  clear
  222  ll
  223  mysql -utransporte  -p svs_web -h CONTSPTRS02 < atualizacaoVersao2_09.sql
  224  sudo su transportes
  225  cp nav.war /home/transportes/
  226  sudo cp nav.war /home/transportes/
  227  sudo su transportes
  228  exit
  229  sudo su transportes
  230  sudo su transportes
  231  cd /transportes/
  232  ls
  233  cd app/
  234  ls
  235  cd transportes/
  236  ls
  237  cd apache-tomcat-8.5.27/
  238  ls
  239  cd logs/
  240  ls
  241  ls -ltra
  242  ls -lhar|grep catalin
  243  ls -lhatr|grep catalin
  244  cp catalina.2020-02-03.log catalina.2020-02-04.log catalina.out /tmp/
  245  sudo cp catalina.2020-02-03.log catalina.2020-02-04.log catalina.out /tmp/
  246  chmod 777 /tmp/catalina.*
  247  sudo chmod 777 /tmp/catalina.*

