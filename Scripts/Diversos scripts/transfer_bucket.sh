#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
SOURCEBACKUP=$(date +'%Y-%m-%d')

cd /backup

gsutil -m rm -rf gs://gru
gsutil -m cp -r $SOURCEBACKUP gs://gru 
