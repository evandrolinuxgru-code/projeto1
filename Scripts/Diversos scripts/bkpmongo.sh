#!/bin/bash


##dump

mongodump --host localhost --port 27027 --verbose  --out /data/backup/ --username mongobackup --password "m0dfwefrwqefwefCkU!)"

##compactacao

/bin/tar -cvzf /data/backup-mongo.tar.gz /data/backup/

##transferencia

scp -i /home/ec2-user/contmaticvirginia.pem /data/backup-mongo.tar.gz ec2-user@172.31.30.221:/data/
