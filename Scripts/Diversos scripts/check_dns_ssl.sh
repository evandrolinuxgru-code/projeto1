#! /bin/sh

host=$1
port=$2
proto=$3


subject=`openssl s_client -servername $host -host $host -port $port -showcerts $starttls -prexit </dev/null 2>/dev/null | sed -n '/BEGIN CERTIFICATE/,/END CERT/p' | openssl x509 -text 2>/dev/null | sed -n 's/ *Subject: CN=*//p'`

if [[ "$subject" == "$host" ]];
then
 #Certificado igual ao DNS
	echo 0
else
 #Certificado diferente do DNS
	echo 1
fi

