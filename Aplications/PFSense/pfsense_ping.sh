#!/bin/sh

DEST="$1"
SRC="$2"

if [ -z "$DEST" ]; then
  echo "falha"
  exit 2
fi

# Se foi informado source, tenta usar -S (FreeBSD/pfSense aceita seleção de endereço fonte).
# Envia 3 echo-request; descarta output; retorna sucesso se houver resposta.
if [ -n "$SRC" ]; then
  /sbin/ping -c 3 -S "$SRC" "$DEST" >/dev/null 2>&1
else
  /sbin/ping -c 3 "$DEST" >/dev/null 2>&1
fi

if [ $? -eq 0 ]; then
  echo "sucesso"
  exit 0
else
  echo "falha"
  exit 1
fi
