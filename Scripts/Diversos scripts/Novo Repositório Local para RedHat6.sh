cat >/etc/yum.repos.d/rhel6-local.repo <<'EOF'
[rhel6-base]
name=RHEL 6 Base
baseurl=http://10.36.52.253/repos/rhel6/rhel-6-server-rpms/
enabled=1
gpgcheck=0

[rhel6-els]
name=RHEL 6 ELS
baseurl=http://10.36.52.253/repos/rhel6/rhel-6-server-retired-els-rpms/
enabled=1
gpgcheck=0

[rhel6-els-optional]
name=RHEL 6 ELS Optional
baseurl=http://10.36.52.253/repos/rhel6/rhel-6-server-retired-els-optional-rpms/
enabled=1
gpgcheck=0
EOF