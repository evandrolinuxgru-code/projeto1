1- Criar script conexoes.sh para registrar conexões em /var/log/conexoes.log

sudo su
mkdir /var/log/conexoes
cd ~
echo '#!/bin/bash ' > conexoes.sh
echo "data=\$(date +"%d-%m-%y") " >> conexoes.sh
echo "exclude=\"127.0.0.1*.*127.0.0.1\"" >> conexoes.sh
echo "" >> conexoes.sh
echo "netstat -tunp | grep -v \$exclude | grep  ESTAB|  awk '{ print \" - \" \$4 \" - \" \$5 \" - \" \$7}' | sed -e \"s/^/\$(date +%d-%m-%Y-%H:%M:%S) /g\" >> /var/log/conexoes/conexoes-\$data.log" >> conexoes.sh
echo "" >> conexoes.sh
echo "find /var/log/conexoes -type f -name \"conexoes*\" -mtime +7 | xargs gzip" >> conexoes.sh
echo "find /var/log/conexoes -type f -name \"conexoes*\" -mtime +90 | xargs rm -rf" >> conexoes.sh

chmod +x conexoes.sh

echo "* * * * * /root/conexoes.sh" >> /var/spool/cron/root

./conexoes.sh

crontab -l

crontab -e