#!/bin/bash 
data=$(date +%d-%m-%y) 
exclude=":1514\|127.0.0.1*.*127.0.0.1"

netstat -tunp | grep -v $exclude | grep  ESTAB|  awk '{ print " - " $4 " - " $5 " - " $7}' | sed -e "s/^/$(date +%d-%m-%Y-%H:%M:%S) /g" >> /var/log/conexoes/conexoes-$data.log

find /var/log/conexoes -type f -name "conexoes*" -mtime +7 | xargs gzip
find /var/log/conexoes -type f -name "conexoes*" -mtime +90 | xargs rm -rf
