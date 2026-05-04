#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
#Entra no diretório Contmatic
cd /Contmatic

#Setando permissões SGID para forçar grupo pai nas subpastas
chmod g+s *

#Lista todas as pastas do diretório Contmatic 
for diretorio_cliente in `ls -1`; do

#Lista o grupo do Active Directory com o nome da pasta
grupo_cliente_dominio=`wbinfo -g | grep contmatic | grep contmatic'.'$diretorio_cliente'-'`
#Captura do numero do cliente do grupo do Active Directory 
numero_diretorio_dominio=`echo "$grupo_cliente_dominio" | sed "s/contmatic.//" | sed "s/-.*//"`
#Lista a permissão ACL da pasta do cliente
permissao_diretorio=`getfacl $diretorio_cliente | grep contmatic | grep ^group | sed "s/group://" | sed "s/:.*//"`
#Lista a permissão Linux da pasta do cliente
permissao_diretorio_linux=`ls -ld $diretorio_cliente | awk '{print $4}'`
echo "------------------"
echo "diretorio_cliente $diretorio_cliente"
echo "grupo_cliente_dominio $grupo_cliente_dominio"
echo "numero_diretorio_dominio $numero_diretorio_dominio"
echo "permissao_diretorio $permissao_diretorio"
echo "permissao_diretorio_linux $permissao_diretorio_linux"

if [[ "$diretorio_cliente" ==  "$numero_diretorio_dominio" ]]; then

	if [[ "$grupo_cliente_dominio" != "$permissao_diretorio" ]]; then

		setfacl -b "$diretorio_cliente"
		setfacl -b "$diretorio_cliente"/*
		setfacl -d -R -m g:"$grupo_cliente_dominio":rwx "$diretorio_cliente"
		setfacl -R -m g:"$grupo_cliente_dominio":rwx "$diretorio_cliente"
		chmod -R 775 "$diretorio_cliente"
		chown root:"$grupo_cliente_dominio" "$diretorio_cliente"
		echo "------------------"
		echo "`date '+%Y-%m-%d %H:%M:%S'` - Setando permissão ACL para $diretorio_cliente grupo $grupo_cliente_dominio" >> /root/log_permissao.log
	else
	echo "------------------"
		echo "`date '+%Y-%m-%d %H:%M:%S'` - Permissão ACL ok para $diretorio_cliente grupo $grupo_cliente_dominio" >> /root/log_permissao.log
	fi
	
	if [[ "$grupo_cliente_dominio" != "$permissao_diretorio_linux" ]]; then
		chmod -R 775 "$diretorio_cliente"
		chown -R root:"$grupo_cliente_dominio" "$diretorio_cliente"
		echo "------------------"
		echo "`date '+%Y-%m-%d %H:%M:%S'` - Setando permissão linux para $diretorio_cliente grupo $grupo_cliente_dominio" >> /root/log_permissao.log
	else
	echo "------------------"
		echo "`date '+%Y-%m-%d %H:%M:%S'` - Permissão linux ok para $diretorio_cliente grupo $grupo_cliente_dominio" >> /root/log_permissao.log
	fi
fi
done
