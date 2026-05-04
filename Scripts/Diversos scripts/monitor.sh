#!/bin/sh

Data=`date`
Report=/home/monitor/permissoes.txt

mysql -uroot -pCondssfsdb3 information_schema -t -e  'select grantee as Usuario, table_schema as Base, privilege_type Privilegio FROM schema_privileges order by grantee Asc, table_schema Asc, privilege_type Asc ;' > /home/monitor/permissoes.txt

(echo "Subject: Report: Permissoes DB CONTSPBDM01 - $Data"  ; echo; cat $Report ) | /usr/sbin/sendmail infra@gru.com.br
