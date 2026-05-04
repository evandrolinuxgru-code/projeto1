#!/bin/sh
USUARIOS=temp
DATA=`date`

echo "db.system.users.find({}, { db: 1, user: 1})" | mongo 127.0.0.1:27027/admin --username mongobackup --password 'm0ngfwfefwecweCkU!)' --authenticationDatabase admin | sed "s/\"//g" | sed "/connecting/d" | sed "/shell/d" | sed "s/bye//" > $USUARIOS

(echo "Subject: Report: Permissoes MongoDB Connectcont 1000IOPs - $DATA"  ; echo; cat $USUARIOS ) | /usr/sbin/sendmail -f monitor@gru.inf.br -t evandro@gru.com.br

echo 0 > $USUARIOS

