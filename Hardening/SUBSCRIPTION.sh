# NOME DE USUÁRIO DA ORGANIZAÇÃO NO PORTAL RED HAT
Username: servers.managers
Password: B0ra#$%RHgru83

# REGISTRAR O SISTEMA COM USUÁRIO/SENHA (A SENHA PODE SER SOLICITADA INTERATIVAMENTE)
Observação: Para redhat 6 se der erro(yum update subscription-manager python-rhsm libcurl curl openssl -y)
subscription-manager repos --enable=rhel-6-server-optional-rpms && \
subscription-manager repos --enable=rhel-6-server-retired-els-rpms
  
subscription-manager register --force --username=servers.managers --password=B0ra#$%RHgru83
subscription-manager refresh
 
# ANEXAR AUTOMATICAMENTE A UMA ASSINATURA VÁLIDA
subscription-manager attach --auto 

# LISTAR ASSINATURAS CONSUMIDAS
subscription-manager list --consumed 

# ATUALIZAR STATUS DA ASSINATURA
subscription-manager refresh 
subscription-manager status

# PROCURAR POOL ID DISPONÍVEL
subscription-manager list --available

# ANEXAR A UMA ASSINATURA ESPECÍFICA VIA POOL ID
subscription-manager attach --pool=8a85f99f799088890179f273314a62d7

# DESREGISTRAR O SISTEMA COMPLETAMENTE LIMPAR CACHE DO YUM E ARQUIVOS DE CERTIFICADOS ANTIGOS 
subscription-manager remove --all
subscription-manager unregister
subscription-manager clean

yum clean all
rm -rf /var/cache/yum
rm -rf /etc/pki/consumer/
rm -rf /etc/pki/entitlement/
rm -rf /tmp/*

#LIMPAR TUDO - UTIL PARA IMAGENS
cat > ~/clean.sh <<EOF
#!/bin/bash

# stop logging services
/usr/bin/systemctl stop rsyslog
/usr/bin/service stop auditd

# remove old kernels
# /bin/package-cleanup -oldkernels -count=1

#clean yum cache
/usr/bin/yum clean all

#force logrotate to shrink logspace and remove old logs as well as truncate logs
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda
/bin/rm -rf /var/log/prompt.log
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

#remove udev hardware rules
/bin/rm -f /etc/udev/rules.d/70*

#remove uuid from ifcfg scripts
/bin/cat > /etc/sysconfig/network-scripts/ifcfg-ens192 <<EOM
DEVICE=ens192
ONBOOT=yes
EOM
/bin/cat > /etc/sysconfig/network-scripts/ifcfg-ens33 <<EOM
DEVICE=ens33
ONBOOT=yes
EOM

#remove SSH host keys
/bin/rm -f /etc/ssh/*key*

#remove root users shell history
/bin/rm -f ~root/.bash_history
unset HISTFILE

#remove root users SSH history
/bin/rm -rf ~root/.ssh/known_hosts
EOF

rm -rf ~/clean.sh
#systemctl poweroff

# ATUALIZAR REPOSITÓRIOS E PACOTES
yum repolist
yum upgrade

