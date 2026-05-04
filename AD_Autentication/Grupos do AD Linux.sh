Grupos Sugeridos:

GG_LINUX_ACESSO_ROOT - Acesso Full 
GG_LINUX_ADMIN - Acesso Admin, comandos sensiveis bloqueados
GG_LINUX_OPERATOR - Acesso Operador, comandos básicos e métricas do SO
======================================================
Função de cada grupo

GG_LINUX_ACESSO_ROOT
Acesso total (equivalente root)

GG_LINUX_ACESSO_ADMIN
Administração: serviços, pacotes, usuários, rede, logs
Sem shell root irrestrito

GG_LINUX_ACESSO_OPERATOR
Operação: status, restart controlado, leitura de logs

=======================================================
cat > /etc/sudoers.d/00-base <<'SUDOEOF1'
Defaults env_reset
Defaults use_pty
Defaults logfile="/var/log/sudo.log"
Defaults log_input,log_output
Defaults passwd_timeout=1
Defaults timestamp_timeout=5
SUDOEOF1

cat > /etc/sudoers.d/10-root <<'SUDOEOF2'
%GG_LINUX_ROOT ALL=(ALL:ALL) NOPASSWD: ALL
SUDOEOF2

cat > /etc/sudoers.d/20-admin <<'SUDOEOF3'
Cmnd_Alias ADMIN_COMANDS = \
/usr/bin/dnf install *, /usr/bin/dnf update *, /usr/bin/dnf remove *, \
/usr/bin/yum install *, /usr/bin/yum update *, /usr/bin/yum remove *, \
/usr/bin/apt install *, /usr/bin/apt upgrade, /usr/bin/apt remove *, \
/bin/systemctl status *, \
/bin/systemctl restart httpd, \
/bin/systemctl restart nginx, \
/bin/systemctl restart apache2, \
/bin/systemctl restart zabbix-agent*, \
/usr/bin/journalctl *, \
/usr/bin/tail *, \
/usr/bin/less *

%GG_LINUX_ADMIN ALL=(ALL) NOPASSWD: ADMIN_COMANDS
SUDOEOF3

cat > /etc/sudoers.d/30-operator <<'SUDOEOF4'
Cmnd_Alias OPERATOR_COMANDS = \
/bin/systemctl status *, \
/usr/bin/journalctl *, \
/usr/bin/tail *, \
/usr/bin/less *, \
/usr/bin/df -h, \
/usr/bin/free, \
/usr/bin/uptime

%GG_LINUX_OPERATOR ALL=(ALL) NOPASSWD: OPERATOR_COMANDS
SUDOEOF4

chown root:root /etc/sudoers.d/00-base /etc/sudoers.d/10-root /etc/sudoers.d/20-admin /etc/sudoers.d/30-operator
chmod 0440 /etc/sudoers.d/00-base /etc/sudoers.d/10-root /etc/sudoers.d/20-admin /etc/sudoers.d/30-operator

visudo -cf /etc/sudoers