#!/bin/bash

# Diretórios alvo
DIR1="/u01/app/grid/product/11.2.0/grid/rdbms/audit"
DIR2="/u01/app/oracle/diag/asm/+asm/+ASM2/trace"

cd $DIR1
if [ "$DIR1" == "$PWD" ]; then

find . -type f -name "*.aud" -mtime +1 | head >> /tmp/teste

  #find . -type f -name "*.aud" -mtime +1 -exec rm -f {} \;
  
else
  echo ""
fi

# Verificar e limpar o diretório 2
cd $DIR2
if [ "$DIR2" == "$PWD" ]; then

find . -type f -name "*.trm" -mtime +1 | head >> /tmp/teste
find . -type f -name "*.trc" -mtime +1 | head >> /tmp/teste

  #find . -type f -name "*.trm" -mtime +1 -exec rm -f {} \;
  #find . -type f -name "*.trc" -mtime +1 -exec rm -f {} \;

else
  echo ""
fi
