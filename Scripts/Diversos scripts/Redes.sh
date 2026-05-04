#Rotas Linux
ip route add 172.16.0.0/20 via 192.168.5.248
ip route add 172.16.255.252/30 via 192.168.5.248
ip route add 10.80.230.0/24 via 192.168.5.248
ip route add 192.168.99.0/24 via 192.168.5.248
ip route add 10.0.0.0/23 via 192.168.4.1

#ESX 
esxcfg-route -a  172.16.0.0/20 192.168.5.248
esxcfg-route -a  172.16.255.252/30 192.168.5.248
esxcfg-route -a  10.80.230.0/24 192.168.5.248
esxcfg-route -a  192.168.99.0/24 192.168.5.248

#Rotas fixa windows
route add -p 172.16.0.0 mask 255.255.240.0 192.168.5.248
route add -p 172.16.255.252 mask 255.255.255.252 192.168.5.248
route add -p 10.80.230.0 mask 255.255.255.0 192.168.5.248
route add -p 192.168.99.0 mask 255.255.255.0 192.168.5.248
route add -p 10.0.0.0 mask 255.255.254.0 192.168.4.1

#Rotas fixa linux
echo "10.80.230.0/24 via 192.168.5.248 dev ens192" > /etc/sysconfig/network-scripts/route-ens192
echo "172.16.0.0/20 via 192.168.5.248 dev ens192" >> /etc/sysconfig/network-scripts/route-ens192
echo "172.16.255.252/30 via 192.168.5.248 dev ens192" >> /etc/sysconfig/network-scripts/route-ens192
echo "10.0.0.0/23 via 192.168.4.1 dev ens192" >> /etc/sysconfig/network-scripts/route-ens192
service network restart

#trocar gw
ip route del default via 192.168.5.166
ip route add default via 192.168.4.1

ip route del default via 192.168.5.248
ip route add default via 192.168.4.1

ip route del default via 192.168.4.1
ip route add default via 192.168.5.166

ip route del default via 192.168.5.166
ip route add default via 192.168.5.248

ip route add 10.80.230.0/23 via 192.168.5.248
ip route add 172.16.0.0/20 via 192.168.5.248

ip route add 10.0.0.0/23 via 192.168.4.1
ip route add 192.168.8.0/24 via 192.168.4.1
ip route add 192.168.9.0/24 via 192.168.4.1
ip route add 192.168.120.0/24 via 192.168.4.1

ip route add default via 192.168.4.1
ip route add default via 192.168.4.1

10.0.0.0/23 via 192.168.4.1 dev ens192
192.168.8.0/24 via 192.168.4.1 dev ens192
192.168.9.0/24 via 192.168.4.1 dev ens192
192.168.120.0/24 via 192.168.4.1 dev ens192

route add -p 10.0.0.0 mask 255.255.254.0 192.168.4.1
route add -p 192.168.8.0/24 mask 255.255.254.0 192.168.4.1
route add -p 192.168.9.0/24 mask 255.255.254.0 192.168.4.1
route add -p 192.168.120.0/24 mask 255.255.254.0 192.168.4.1

#IPs de saida Contmatic

177.92.74.192/26 mundivox
177.190.204.64/26 cti
201.63.226.0/24 vivo

##meu ip de saida
dig +short myip.opendns.com @resolver1.opendns.com
curl http://checkip.amazonaws.com/

#regras firewalld
setar:
firewall-cmd --permanent --add-port=2500-5000/tcp 
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
firewall-cmd --zone=public --query-port=7071/tcp
firewall-cmd --permanent --remove-port=8443/tcp
firewall-cmd --zone=public --remove-port=80/tcp

firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload

firewall-cmd --zone=home --change-interface=eth0
firewall-cmd --get-zones

firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='192.151.208.18' reject"
firewall-cmd --add-port=3456/tcp --permanent
FTP:
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -p TCP --dport 21 --sport 1024:65534 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -p TCP --dport 65400:65410 --sport 1024:65534 -j ACCEPT

firewall-cmd --permanent --direct --get-all-rules

#LISTAR REGRAS
firewall-cmd --list-all-zones

firewall-cmd --list-all

#CRIAR REGRA SSH GRU
firewall-cmd --permanent --remove-port=22/tcp && \
firewall-cmd --permanent --remove-service=ssh && \
firewall-cmd --permanent --zone=public --remove-port=22/tcp && \
firewall-cmd --permanent --zone=public --remove-service=ssh && \

firewall-cmd --permanent --new-zone=mysshzone && \

firewall-cmd --permanent --zone=mysshzone --add-service=ssh && \
firewall-cmd --permanent --zone=mysshzone --add-source=172.31.46.20/32 && \
firewall-cmd --permanent --zone=mysshzone --add-source=172.31.46.21/32 && \
firewall-cmd --permanent --zone=mysshzone --add-source=172.31.49.176/32 && \
firewall-cmd --reload

#UFW
ufw allow from 172.31.46.20 to any port 22 && \
ufw allow from 172.31.46.21 to any port 22 && \
ufw allow from 172.31.49.176 to any port 22 && \
ufw deny 22 && \
echo y | ufw enable && \
ufw status

ufw status numbered
ufw allow 80
ufw delete 2

##disable icmp ping
echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo "net.ipv4.icmp_echo_ignore_all = 0" >> /etc/sysctl.conf 
sysctl -p

#TCPDUMP
tcpdump -nni any

semanage port -a -t ssh_port_t -p tcp 2289
firewall-cmd --permanent --add-port=2289/tcp
firewall-cmd --reload