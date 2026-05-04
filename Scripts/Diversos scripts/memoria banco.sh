senha github =  http://contshpoe02/ usuário: wagner.correa senha: 12345678 depois trocar senha

mysqldump -h172.31.0.11 -uroot -p -a -v --max_allowed_packet 2G --single-transaction --all-databases | gzip  > /backup/dump_full/bk_div_full.sql.gz
bk_div_full_

mysqldump -uroot -p -a -v --opt --max_allowed_packet 2G --single-transaction --databases automacao_web | gzip  > /backup/gestao.sql.gz

mysqldump -uroot -pCon3232320b3 -a -v --opt --max_allowed_packet 2G --single-transaction --databases blogfundacao | gzip  > /data/dump_blogfundacao.sql.gz
gunzip < /data/backup/dump_fundacao.sql.gz | mysql -uroot -p fundacao


scp -i /root/chave/private-infra.pem /data/dump_blognovosoftmatic.sql.gz root@192.168.5.83:/root/backup/


automacao_web_new

gunzip < dump_automacao_web.sql.gz | mysql -uroot -pvv!yjRyXJ5*p automacao_web_new


-- API aquivos
mongodump --host 127.0.0.1 --port 27000 --username master --password '123456789' --authenticationDatabase admin --out /backup/backup_mongo/ --db connect_cont


pg_dumpall | gzip -9 > /root/backup/CRM-$DATA.gz
sudo -u postgres pg_dump CRM | gzip -9 > CRM.sql.gz
pg_restore.exe --host "192.168.5.96" --port "5432" --username "postgres" --no-password --role "postgres" --dbname "CRM_NEW" --verbose

mysqldump -uroot -p -v --opt --max_allowed_packet 2G --single-transaction --databases automacao_web | gzip > /data/atomacao_web.sql.gz
mysqldump -h172.31.0.11 -uroot -p -a -v --opt --max_allowed_packet 2G --single-transaction --all-databases | gzip  > /backup/dump_full/bk_div_full.sql.gz
mysqldump -uroot -pCont#@10b3 -a -v --opt --max_allowed_packet 2G --single-transaction --databases blogfundacao | gzip  > /data/dump_blogfundacao.sql.gz
gunzip < dump_legalmatic.sql.gz | mysql -uroot -p legalmatic

mysqldump -uroot -p --opt -a -v --max_allowed_packet 2G --single-transaction --all-databases | gzip  > /backup/dump_full/bk_alldb_diversos_$(date +%d-%m-%Y-%H%M%S).sql.gz

mysqldump -uroot -p -a -v --single-transaction --databases otrs > otrs.sql

8U0iK5f.

create user 'cliente'@'192.168.5.161' IDENTIFIED BY '2+rTFzw=PY';
GRANT all ON cliente.* To 'cliente'@'192.168.5.161' IDENTIFIED BY '2+rTFzw=PY';
flush privileges;

172.31.0.7

mongodump –-collection empresa –-db gestor_empresa

mongodump -h localhost --port 27027 --verbose –c empresa –d gestor_empresa --out  /backup/ --username mongobackup --password 'm0ngfsdfsdf@CkU!)'
mongodump -h localhost --port 27027 --verbose --authenticationDatabase admin --collection usuario --db connect_cont  --out /backup/backup_usuario --username mongobackup --password 'm0ngO!3@CkU!)'
mongodump --host 127.0.0.1 --port 27000 --username master --password '123456789' --authenticationDatabase admin --out /data/backup/backup_mongo --db arquivo
mongodump --host 127.0.0.1 --port 27000 --username master --password '123456789' --authenticationDatabase admin --out /backup/backup_mongo/ --db arquivo

mongorestore --host localhost --port 27017 --verbose --username mongobackup --password 'm0ngO!3@CkU!)'  --db connect_cont --authenticationDatabase admin /

scp -i /root/chave/private-infra.pem /data/dump_legalmatic.sql.gz infra@192.168.5.213:/data/backup/

gru@site
cont@site123

mysqldump -h 35.192.35.162 -uroot -p8U0iK5f. --opt -a -v --max_allowed_packet 2G --single-transaction --all-databases | gzip  > /var/lib/mysql/backup/bk_alldb_portal_$(date +%d-%m-%Y-%H%M%S).sql.gz
mysqldump -hlocalhost  -uroot -p -v --single-transaction --databases novoportal | gzip > /data/novoportal.sql.gz
mysqldump -uroot -p -f --no-data --quote-names automacao_web > /backup/backup_estrutura_web.sql

gestaoliquibase password: 1qaz2wsxcont


Windup = 192.168.5.83 - teste migração

https://kb.elipse.com.br/configuracoes-para-disponibilizar-o-sql-server-na-rede/

cpf veronica: 267.843.418-48
senha clubextra B4rb4r3l4$


mysqldump -uroot -p'd4XGZYNF' -v --databases portal | gzip > /portal.sql.gz

pg_dump -U username -W -F t database_name > c:\backup_file.tar

sudo -u postgres pg_dump CRM | gzip -9 > CRM.sql.gz


mysqldump -uroot -p'cqepvc' --single-transaction --all-databases | gzip > contspbdm02+date '+%d-%m-%Y-%H%M'.sql.gz
mysqldump -uroot -p -v -h 35.199.67.146 --single-transaction automacao_web | gzip >  /backup/automacaoweb.sql.gz
scp /data/backup/full/contspbdm04-$(date '+%d-%m-%Y').tar.gz root@192.168.99.12:/backup/banco/contspbdm04/


date '+%d-%m-%Y-%H%M'


/root/backup/full

177.126.188.205

192.168.5.96
scp -i /root/chave/private-infra.pem /data/novoportal.sql.gz infra@34.74.127.128:/backup/

tar -cvf /data/backup/full/contspbdm04-$(date '+%d-%m-%Y').tar.gz /data/backup/full/

scp teste_bd root@192.168.99.12:/backup/banco/contspbdm01/

gunzip -c CRM.sql.gz | psql CRM_Homolog
psql -U postgres -d CRM_Homolog < CRM.sql

REVOKE all ON *.* from 'portal'@'%';

scp -r /backup/backup_mongo/arquivo/ root@179.185.132.14:/banco/