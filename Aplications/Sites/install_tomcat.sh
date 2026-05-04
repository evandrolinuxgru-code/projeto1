#!/bin/bash

######################################
# EXECUTAR O SCRIPT ABAIXO COMO SUDO #
######################################

PROJECT_FOLDER=$1
PORT=$2
SHUTDOWN_PORT=$3
AJP_PORT=$4
REDIRECT_PORT=$5
PROFILE=$6

rm -r /usr/local/${PROJECT_FOLDER}
rm -r /opt/${PROJECT_FOLDER}_jdk
rm -r /opt/${PROJECT_FOLDER}_tomcat

mkdir /usr/local/${PROJECT_FOLDER}
cd /usr/local/${PROJECT_FOLDER}
#wget https://cdn.azul.com/zulu/bin/zulu8.48.0.49-ca-jdk8.0.262-linux_x64.tar.gz
wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u282-b08_openj9-0.24.0/OpenJDK8U-jdk_x64_linux_openj9_8u282b08_openj9-0.24.0.tar.gz
wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.64/bin/apache-tomcat-8.5.64.tar.gz
#tar -xvf zulu8.48.0.49-ca-jdk8.0.262-linux_x64.tar.gz
tar -xvf OpenJDK8U-jdk_x64_linux_openj9_8u282b08_openj9-0.24.0.tar.gz
tar -xvf apache-tomcat-8.5.64.tar.gz
#ln -s /usr/local/${PROJECT_FOLDER}/zulu8.48.0.49-ca-jdk8.0.262-linux_x64 /opt/${PROJECT_FOLDER}_jdk
ln -s /usr/local/${PROJECT_FOLDER}/jdk8u282-b08 /opt/${PROJECT_FOLDER}_jdk
ln -s /usr/local/${PROJECT_FOLDER}/apache-tomcat-8.5.64 /opt/${PROJECT_FOLDER}_tomcat

touch /etc/systemd/system/tomcat_${PROJECT_FOLDER}.service

echo "# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target
[Service]
Type=forking
WorkingDirectory=/opt/${PROJECT_FOLDER}_tomcat
Environment=JAVA_HOME=/opt/${PROJECT_FOLDER}_jdk/jre
Environment=CATALINA_PID=/opt/${PROJECT_FOLDER}_tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/${PROJECT_FOLDER}_tomcat
Environment=CATALINA_BASE=/opt/${PROJECT_FOLDER}_tomcat
Environment='CATALINA_OPTS=-Xms32M -Xmx1024M -Xgc:concurrentScavenge -XX:+CompactStrings -XX:+IdleTuningGcOnIdle -Xtune:virtualized -Xshareclasses:name=API_SCC -Xscmx1g -Dspring.profiles.active=${PROFILE}'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=${PROFILE} -Dhttp.port=${PORT} -Dshutdown.port=${SHUTDOWN_PORT} -Dajp.port=${AJP_PORT} -Dredirect.port=${REDIRECT_PORT}'
ExecStart=/opt/${PROJECT_FOLDER}_tomcat/bin/catalina.sh start
#ExecStop=/bin/kill -15 \$MAINPID
ExecStop=/opt/${PROJECT_FOLDER}_tomcat/bin/shutdown.sh

LimitNOFILE=500000
LimitNPROC=500000

User=root
Group=root
UMask=0007
RestartSec=10
Restart=always
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat_${PROJECT_FOLDER}.service

mv /opt/${PROJECT_FOLDER}_tomcat/conf/server.xml /opt/${PROJECT_FOLDER}_tomcat/conf/server.xml_old

echo '<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!-- Note:  A "Server" is not itself a "Container", so you may not
     define subcomponents such as "Valves" at this level.
     Documentation at /docs/config/server.html
 -->
<Server port="${shutdown.port}" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.startup.VersionLoggerListener" />
  <!-- Security listener. Documentation at /docs/config/listeners.html
  <Listener className="org.apache.catalina.security.SecurityListener" />
  -->
  <!--APR library loader. Documentation at /docs/apr.html -->
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <!-- Prevent memory leaks due to use of particular java/javax APIs-->
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />

  <!-- Global JNDI resources
       Documentation at /docs/jndi-resources-howto.html
  -->
  <GlobalNamingResources>
    <!-- Editable user database that can also be used by
         UserDatabaseRealm to authenticate users
    -->
    <Resource name="UserDatabase" auth="Container" 
              type="org.apache.catalina.UserDatabase" 
              description="User database that can be updated and saved" 
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory" 
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>

  <!-- A "Service" is a collection of one or more "Connectors" that share
       a single "Container" Note:  A "Service" is not itself a "Container",
       so you may not define subcomponents such as "Valves" at this level.
       Documentation at /docs/config/service.html
   -->
  <Service name="Catalina">

    <!--The connectors can use a shared executor, you can define one or more named thread pools-->
    <!--
    <Executor name="tomcatThreadPool" namePrefix="catalina-exec-" 
        maxThreads="150" minSpareThreads="4"/>
    -->

    <!-- A "Connector" represents an endpoint by which requests are received
         and responses are returned. Documentation at :
         Java HTTP Connector: /docs/config/http.html
         Java AJP  Connector: /docs/config/ajp.html
         APR (HTTP/AJP) Connector: /docs/apr.html
         Define a non-SSL/TLS HTTP/1.1 Connector on port 8080
    -->
     <Connector port="${http.port}" protocol="HTTP/1.1" 
               connectionTimeout="20000" maxThreads="800" maxHttpHeaderSize="1000000" 
               compression="on" useSendfile="false" compressionMinSize="0" 
               redirectPort="${redirect.port}" />
    <!-- A "Connector" using the shared thread pool-->
    <!--
    <Connector executor="tomcatThreadPool" 
               port="8080" protocol="HTTP/1.1" 
               connectionTimeout="20000" 
               redirectPort="8443" />
    -->
    <!-- Define an SSL/TLS HTTP/1.1 Connector on port 8443
         This connector uses the NIO implementation. The default
         SSLImplementation will depend on the presence of the APR/native
         library and the useOpenSSL attribute of the
         AprLifecycleListener.
         Either JSSE or OpenSSL style configuration may be used regardless of
         the SSLImplementation selected. JSSE style configuration is used below.
    -->
    <!--
    <Connector port="${redirect.port}" protocol="org.apache.coyote.http11.Http11NioProtocol" 
               maxThreads="150" SSLEnabled="true">
        <SSLHostConfig>
            <Certificate certificateKeystoreFile="conf/localhost-rsa.jks" 
                         type="RSA" />
        </SSLHostConfig>
    </Connector>
    -->
    <!-- Define an SSL/TLS HTTP/1.1 Connector on port 8443 with HTTP/2
         This connector uses the APR/native implementation which always uses
         OpenSSL for TLS.
         Either JSSE or OpenSSL style configuration may be used. OpenSSL style
         configuration is used below.
    -->
    <!--
    <Connector port="${redirect.port}" protocol="org.apache.coyote.http11.Http11AprProtocol" 
               maxThreads="150" SSLEnabled="true" >
        <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol" />
        <SSLHostConfig>
            <Certificate certificateKeyFile="conf/localhost-rsa-key.pem" 
                         certificateFile="conf/localhost-rsa-cert.pem" 
                         certificateChainFile="conf/localhost-rsa-chain.pem" 
                         type="RSA" />
        </SSLHostConfig>
    </Connector>
    -->

    <!-- Define an AJP 1.3 Connector on port 8009 -->
    <!--
    <Connector protocol="AJP/1.3" 
               address="::1" 
               port="${ajp.port}" 
               redirectPort="${redirect.port}" />
    -->

    <!-- An Engine represents the entry point (within Catalina) that processes
         every request.  The Engine implementation for Tomcat stand alone
         analyzes the HTTP headers included with the request, and passes them
         on to the appropriate Host (virtual host).
         Documentation at /docs/config/engine.html -->

    <!-- You should set jvmRoute to support load-balancing via AJP ie :
    <Engine name="Catalina" defaultHost="localhost" jvmRoute="jvm1">
    -->
    <Engine name="Catalina" defaultHost="localhost">

      <!--For clustering, please take a look at documentation at:
          /docs/cluster-howto.html  (simple how to)
          /docs/config/cluster.html (reference documentation) -->
      <!--
      <Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"/>
      -->

      <!-- Use the LockOutRealm to prevent attempts to guess user passwords
           via a brute-force attack -->
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <!-- This Realm uses the UserDatabase configured in the global JNDI
             resources under the key "UserDatabase".  Any edits
             that are performed against this UserDatabase are immediately
             available for use by the Realm.  -->
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm" 
               resourceName="UserDatabase"/>
      </Realm>

      <Host name="localhost"  appBase="webapps" 
            unpackWARs="true" autoDeploy="true">

        <!-- SingleSignOn valve, share authentication between web applications
             Documentation at: /docs/config/valve.html -->
        <!--
        <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
        -->

        <!-- Access log processes all example.
             Documentation at: /docs/config/valve.html
             Note: The pattern used is equivalent to using pattern="common" -->
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs" 
               prefix="localhost_access_log" suffix=".txt" 
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />

      </Host>
    </Engine>
  </Service>
</Server>' > /opt/${PROJECT_FOLDER}_tomcat/conf/server.xml

systemctl start tomcat_${PROJECT_FOLDER}.service
systemctl enable tomcat_${PROJECT_FOLDER}.service
