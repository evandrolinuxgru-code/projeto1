#teclado
localectl status
localectl list-keymaps | grep br
localectl set-keymap br-abnt2
localectl set-x11-keymap us pc105 altgr-int
localectl set-x11-keymap br

#reset senha centos
rw init=/sysroot/bin/sh
chroot /sysroot
passwd root
touch /.autorelabel
exit
reboot

systemctl restart systemd-sysctl

##chave ppk converter pra pem funcional:
puttygen private-infra.ppk -O private-openssh -o private-infra.pem

#desativar instalação pacote com chave
yum install *** --nogpgcheck  

#memoria
echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3
swapoff -a && swapon -a

#install semanage selinux
yum provides semanage
resultado pra instalar:
policycoreutils-python-2.5-33.el7.x86_64

#auto start enable
chkconfig --add httpd
chkconfig httpd on
chkconfig --list httpd

#corrigir permissões
find . -type f -perm 775 -print -exec chmod 644 {} \;
find . -type d -perm 775 -print -exec chmod 644 {} \;
find . -type d -perm 644 -print -exec chmod 775 {} \;

find /pasta -maxdepth 1 -type d -name "*20" -mtime 0 -exec cp -r {} /pasta/ \;

#horario data timezone
chronyd -q '192.168.5.199 iburst'
chronyc -a makestep
timedatectl list-timezones | grep Sao
timedatectl set-timezone America/Sao_Paulo
yum update tzdata -y

date +"%s" -d "Jan 01 00:00:00 BRST 2000"
date +%T -s "22:20:00"

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
jenkins ALL=(ALL) NOPASSWD: ALL

#apagar varios processos
kill -9 $(ps -aux | grep 'firefox' | awk '{print $2}')

#acesso ftp pelo AD (apos pacote do AD)
vim /etc/ssh/sshd_config
auth     required    pam_ldap.so
account  required    pam_permit.so
session  required    pam_limits.so

#visudo sem senha
%sudo   ALL=(ALL:ALL) ALL
gestao ALL=(ALL) NOPASSWD: ALL

#stress test cpu
fulload() { dd if=/dev/zero of=/dev/null | dd if=/dev/zero of=/dev/null | dd if=/dev/zero of=/dev/null | dd if=/dev/zero of=/dev/null & }; fulload; read; killall dd

#hostname teimoso
bash -c "echo 'kernel.hostname = localhost' >> /etc/sysctl.conf"

mongo  --host 127.0.0.1 --port 27027 --username felipe.machado --password 'Cont@2021' --authenticationDatabase admin

#update gcc
sudo yum install centos-release-scl
sudo yum install devtoolset-7-gcc*
scl enable devtoolset-7 bash
which gcc
gcc --version



























































