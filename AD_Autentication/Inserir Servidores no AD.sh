
Inserir no AD: 

SPRDAPSMGRU01 => RedHat 6.1
SPRDAPSMGRU02 => RedHat 6.1
SHOMAPPOSTGRU01 => RedHat 8 => INGRESSADO NO AD COM SUCESSO
SHOMAPCUPSGRU01 => RedHat 9.7 => INGRESSADO NO AD COM SUCESSO
SHOMAPNFSGRU01 => RedHat 9.7
SHOMAPGRFGRU02 => Ubuntu 22
SHOMAPITSMGRU01 => Ubuntu 24 => INGRESSADO NO AD COM SUCESSO

=======================================================
RedHat 8 e 9
1) Instalar pacotes
dnf install -y realmd sssd sssd-tools adcli oddjob oddjob-mkhomedir samba-common-tools
2) Descobrir domínio
realm discover gru.local
3) Ingressar no domínio
realm join gru.local -U administrador
4) Habilitar criação automática de home
authselect select sssd with-mkhomedir --force
systemctl enable --now oddjobd
5) Ajustar SSSD (controle + cache)
cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf-bkp-_$(date +%d%m%Y-%H%M%S)
cat > /etc/sssd/sssd.conf <<'EOF'
[sssd]
services = nss, pam
config_file_version = 2
domains = gru.local

[domain/gru.local]
id_provider = ad
access_provider = simple

ad_domain = gru.local
krb5_realm = GRU.LOCAL

cache_credentials = True
offline_credentials_expiration = 1

use_fully_qualified_names = False
fallback_homedir = /home/%u
default_shell = /bin/bash

simple_allow_groups = GG_LINUX_ROOT, GG_LINUX_ADMIN, GG_LINUX_OPERATOR

ldap_network_timeout = 3
ldap_opt_timeout = 3
EOF
chmod 600 /etc/sssd/sssd.conf
systemctl restart sssd

=======================================================
Ubuntu 24

1) Instalar pacotes
apt update
apt install -y realmd sssd sssd-tools adcli krb5-user libnss-sss libpam-sss oddjob oddjob-mkhomedir
2) Descobrir domínio
realm discover gru.local
3) Ingressar no domínio
realm join gru.local -U administrador
4) Habilitar criação automática de home
pam-auth-update --enable mkhomedir
systemctl enable --now oddjobd
5) Ajustar SSSD
cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf-bkp-_$(date +%d%m%Y-%H%M%S)
cat > /etc/sssd/sssd.conf <<'EOF'
[sssd]
services = nss, pam
config_file_version = 2
domains = gru.local

[domain/gru.local]
id_provider = ad
access_provider = simple

ad_domain = gru.local
krb5_realm = GRU.LOCAL

cache_credentials = True
offline_credentials_expiration = 1

use_fully_qualified_names = False
fallback_homedir = /home/%u
default_shell = /bin/bash

simple_allow_groups = GG_LINUX_ROOT, GG_LINUX_ADMIN, GG_LINUX_OPERATOR

ldap_network_timeout = 3
ldap_opt_timeout = 3
EOF
chmod 600 /etc/sssd/sssd.conf
systemctl restart sssd