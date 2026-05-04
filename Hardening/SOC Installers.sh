#################################################################### OCS ####################################################################
# Repos RedHAT6 
  yum update -y ca-certificates openssl nss-* && \
  yum install -y https://archives.fedoraproject.org/pub/archive/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
  subscription-manager repos --enable=rhel-6-server-optional-rpms && \
  subscription-manager repos --enable=rhel-6-server-retired-els-rpms && \

#################################################################### GLPI ###################################################################
wget https://github.com/glpi-project/glpi-agent/releases/download/1.9/glpi-agent-1.9-linux-installer.pl

wget http://172.31.49.176:8080/downloads/Glpi/glpi-agent-1.9-linux-installer.pl && \
chmod +x glpi-agent-1.9-linux-installer.pl && ./glpi-agent-1.9-linux-installer.pl -s glpi.gru.com.br -v

################################################################### Elastic ##################################################################
wget http://172.31.49.176:8080/downloads/Elastic/elastic-agent-8.17.4-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.17.4-linux-x86_64.tar.gz

tar -xf elastic-agent-8.17.4-linux-x86_64.tar.gz && \
./elastic-agent-8.17.4-linux-x86_64/elastic-agent install -f --url=https://e009a77f17a343f4a9f461be5f7db78a.fleet.eastus2.azure.elastic-cloud.com:443 --enrollment-token=WTBiOXQ0a0J2MjBKV2MySTA3cnA6NXZSV3ZUUlpRNENTS19oVFBib3RrUQ==

rm -rf elastic-agent*
 
#################################################################### AUDIT ###################################################################
yum -y install audit || apt install -y auditd

#################################################################### QUALYS ##################################################################
wget http://172.31.49.176:8080/downloads/Qualys/QualysCloudAgent.rpm
rpm -ivh QualysCloudAgent.rpm || dpkg --install QualysCloudAgent.deb 
 
/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=192418a7-300e-47cd-a94a-d1c7923a38c8 CustomerId=1b910a46-7e07-400c-835f-94c8cc1c8798 ServerUri=https://qagpublic.qg4.apps.qualys.com/CloudAgent/
rm -rf QualysCloud*

#################################################################### SENTINELONE #############################################################
wget http://172.31.49.176:8080/downloads/Sentinel/SentinelAgent_linux_x86_64_v25_3_2_11.rpm

rpm -i SentinelAgent*.rpm || dpkg -i SentinelAgent*.deb

/opt/sentinelone/bin/sentinelctl management token set eyJ1cmwiOiAiaHR0cHM6Ly91c2VhMS0wMTcuc2VudGluZWxvbmUubmV0IiwgInNpdGVfa2V5IjogImZjMGZmMDNmN2E3NjI1N2QifQ==
/opt/sentinelone/bin/sentinelctl control start
rm -rf SentinelAg*

#############################################################################################################################################################
Para coleta de evidências:

ps aux | egrep --color  "ocsinventory|\qualys-cloud-agent|\elastic-agent$|\auditd|\glpi" && \
/opt/sentinelone/bin/sentinelctl control status && \
date

for s in auditd glpi-agent qualys-cloud-agent elastic-agent sentinelone; do systemctl status $s --no-pager | head -n 7; echo; done

#################################################### HARDENING #######################################################################################################
# 1 - BANNER DE ALERTA APÓS O LOGIN 

cat << EOF > /etc/motd
###############################################################
#              >>> Authorized access only <<<                 #
#      Disconnect IMMEDIATELY if you are not authorized       #
#           All actions are monitored and recorded            #
#         For support contact the IT Infrastructure           #
###############################################################
EOF

if [ -d "/etc/update-motd.d" ]; then
    echo "\#\!/bin/bash" > /etc/update-motd.d/99-motd
	echo "cat /etc/motd" >> /etc/update-motd.d/99-motd
	chmod +x /etc/update-motd.d/99-motd
fi

# 2 - HARDENING DO SSH E RESTRIÇÃO DE ACESSO
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bkp_$(date +%d%m%Y-%H%M%S)

sed -i "/AllowTcpForwarding\|AllowAgentForwarding\|ClientAliveCountMax\|Compression\|LogLevel\
\|MaxAuthTries\|MaxSessions\|PermitEmptyPasswords\|PermitRootLogin\|Port\|Protocol\
\|TCPKeepAlive\|UseDNS\|X11Forwarding/d" /etc/ssh/sshd_config

cat << EOF >> /etc/ssh/sshd_config
AllowAgentForwarding no
AllowTcpForwarding no
AllowUsers *@172.31.46.20 *@172.31.46.21 *@172.31.49.176
ClientAliveCountMax 2
ClientAliveInterval 300
Compression no
LogLevel VERBOSE
MaxAuthTries 2
MaxSessions 2
PermitEmptyPasswords no
PermitRootLogin no
Protocol 2
Port 2289
TCPKeepAlive no
UseDNS no
X11Forwarding no
EOF

semanage port -a -t ssh_port_t -p tcp 2289
semanage port -m -t ssh_port_t -p tcp 2289
firewall-cmd --add-port=2289/tcp --permanent
firewall-cmd --add-service=ssh --permanent
firewall-cmd --reload
echo "FAILLOG_ENAB yes" >> /etc/login.defs
service sshd restart ; service ssh restart

# 3 - HARDENING DO KERNE
cp /etc/sysctl.conf /etc/sysctl.conf-bkp-$(date +%d-%m-%Y-%H-%M)
sed -i "/kernel.*/d" /etc/sysctl.conf
sed -i "/net.*/d" /etc/sysctl.conf
sed -i "/^fs.*/d" /etc/sysctl.conf
sed -i "/^dev.*/d" /etc/sysctl.conf

cat << EOF >> /etc/sysctl.conf
dev.tty.ldisc_autoload = 0 
fs.protected_fifos = 2
fs.protected_regular = 1
fs.protected_regular = 2 
fs.suid_dumpable = 0 
kernel.core_uses_pid = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.perf_event_paranoid = 3
kernel.randomize_va_space = 2
kernel.sysrq = 0
kernel.unprivileged_bpf_disabled = 1
kernel.yama.ptrace_scope = 1
net.core.bpf_jit_harden = 2
net.core.bpf_jit_harden = 2 
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.bootp_relay = 0
net.ipv4.conf.all.forwarding = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.proxy_arp = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.ip_forward = 0
net.ipv4.route.flush = 1
net.ipv4.tcp_syncookies = 1
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.default.disable_ipv6 = 1
EOF

sysctl -p 

# 4 - DEFINIR CONFIGURAÇÕES DE HISTÓRICO, PROMPT CUSTOMIZADO, REGISTRO DE COMANDOS 
HISTORY_FILE="$HOME/.bash_history"
FAKE_TIMESTAMP=946684800
TEMP_FILE=$(mktemp)

while IFS= read -r line; do
    if [[ "$line" != \#* ]]; then
    echo "#$FAKE_TIMESTAMP" >> "$TEMP_FILE"
    fi
    echo "$line" >> "$TEMP_FILE"
done < "$HISTORY_FILE"

mv -f "$TEMP_FILE" "$HISTORY_FILE"

for dir in /home/* /root /etc/skel; do
    sed -i '/HISTSIZE=20000/d; /HISTFILESIZE=20000/d; /HISTCONTROL=ignorespace/d; /HISTTIMEFORMAT="/d; /export whoami=/d; /export PROMPT_COMMAND=/d; /export PS1/d ; /TMOUT=1800/d' $dir/.bashrc
done

for dir in /home/* /root /etc/skel; do
    cat << EOF >> $dir/.bashrc
HISTSIZE=20000
HISTFILESIZE=20000
HISTCONTROL=ignorespace
HISTTIMEFORMAT="%d/%m/%y %T "
export whoami="\$(whoami)@\$(echo \$SSH_CONNECTION | awk '{print \$1}')"
export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local3.debug "\$whoami [\$\$]: \$(history 1 | sed "s/^[ ]*[0-9]\\+[ ]*//") [\$RETRN_VAL]"'
export PS1='\[\033[01;37m\]\u\[\033[01;31m\]@\[\033[01;37m\]\h\[\033[01;31m\][\[\033[01;33m\]\w\[\033[01;31m\]]\[\033[01;37m\]$\[\033[00m\]'
TMOUT=1800
EOF
done

sed -i '/export PS1/d' /root/.bashrc
cat << EOF >> /root/.bashrc
export PS1='\[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;32m\]\h\[\033[01;31m\][\[\033[01;33m\]\w\[\033[01;31m\]]\[\033[01;37m\]#\[\033[00m\]'
EOF

echo 'local3.* /var/log/prompt.log' >> /etc/rsyslog.conf
service rsyslog restart

# 5 - DEFINIÇÃO DE UMASK PARA CRIAR ARQUIVOS RESTRITOS
sed -i "/UMASK/d" /etc/login.defs
echo "UMASK 027" >> /etc/login.defs
echo "umask 027" >> /etc/bash.bashrc
echo "umask 027" >> /etc/profile
echo "umask 027" >> /root/.bashrc
sed -i -e 's/umask 022/umask 027/g' -e 's/umask 002/umask 027/g' /etc/bashrc
sed -i -e 's/umask 022/umask 027/g' -e 's/umask 002/umask 027/g' /etc/csh.cshrc
sed -i -e 's/umask 022/umask 027/g' -e 's/umask 002/umask 027/g' /etc/init.d/functions
sed -i -e 's/umask 022/umask 027/g' -e 's/umask 002/umask 027/g' /etc/profile

# 6 - PERMISSÕES DE ARQUIVOS SENSIVEIS DO SISTEMA
chmod 600 /etc/at.deny /boot/grub2/grub.cfg /etc/crontab /etc/issue.net \
           /etc/issue /etc/motd /etc/cron.deny /etc/ssh/sshd_config /etc/sudoers.d
chmod 700 /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /etc/cron.monthly

# 7 - DESABILITAR PROTOCOLOS DESNECESSÁRIOS
cat <<EOF > /etc/modprobe.d/disable.conf
install dccp /bin/true
install rds /bin/true
install tipc /bin/true
install sctp /bin/true
install usb-storage /bin/true
install firewire-core /bin/true
install firewire-net /bin/true
install firewire-ohci /bin/true
install firewire-sbp2 /bin/true
EOF

# 8 - CONFIGURAR PERSISTENCIA DO JOURNALCTL PARA NÃO PERDER INFORMAÇÕES DE LOG APÓS REBOOT
sed -i "/Storage.*/d" /etc/systemd/journald.conf
echo "#PRESERVA JOURNAL APOS BOOT" >> /etc/systemd/journald.conf
echo "Storage=persistent" >> /etc/systemd/journald.conf
systemctl daemon-reload

# 9 - INSTALAR APLICATIVOS UTEIS
os_version=$(grep -oE '[0-9]+' /etc/redhat-release | head -1)

# Comandos para RedHat 8 e 9
subscription-manager repos --enable codeready-builder-for-rhel-$os_version-$(arch)-rpms
if [ "$os_version" -eq 8 ]; then
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
elif [ "$os_version" -eq 9 ]; then
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
fi

if [ -f /etc/redhat-release ]; then
    yum install -y htop sysstat telnet chrony vim lsof
	echo -e "server 172.31.50.23 iburst\nserver 172.31.50.27 iburst" | sudo tee -a /etc/chrony.conf
	systemctl restart chronyd
else [ -f /etc/os-release ] && grep -q "Ubuntu" /etc/os-release; 
    apt install -y htop sysstat telnet chrony vim lsof
	echo -e "server 172.31.50.23 iburst\nserver 172.31.50.27 iburst" | sudo tee -a /etc/chrony/chrony.conf
	systemctl restart chronyd
fi

# 10 - CRIAR USUÁRIO SYSGRU PARA LOGIN NO SENHA SEGURA
useradd sysgru -m -s /bin/bash
usermod --password '$6$H8j3RfUOvjZ.DDZ7$7FImxF7xK8Eh29BULgwRy2kDhVb3X6yIjt.ROssxjtCLmAd3yMmoZdaYBlCU6W7yjvWezVSNb9MPDJZihcsuC1' sysgru
usermod -aG wheel sysgru
usermod -aG sudo sysgru

echo "sysgru ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sysgru
echo "admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/admin
echo "svc-rp ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/svc-rp

# 11 - Limpar kernels
dnf -y remove --oldinstallonly --setopt installonly_limit=2 kernel
dnf -y remove --oldinstallonly 
package-cleanup --oldkernels --count=1

 > .bash_history ; > /root/.bash_history ; > /home/sysgru/.bash_history ; > /var/log/prompt.log ; history -c

# 12 PESQUISA QUALYS
Vulnerability: vulnerabilities.detectionScore:[ 90 ... 100 ] 
Asset: tags.name:BROKER


