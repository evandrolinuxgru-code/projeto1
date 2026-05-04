#!/bin/bash
BASE_PATH=/transportes/app
JAVA_HOME=/transportes/app/jdk1.8.0_161
TDUMP_FOLDER=tdump

createThreadDump() {
        if [[ -z "$1" ]]; then
            echo "PID DO TRANSPORTES não informado."
            return 1
    fi
    TOMCAT_NAME=$1

        PID=`ps -efda|grep "$TOMCAT_NAME" | grep -v grep | awk '{print $2}'`
        echo "Pid Encontrado: $PID"

    cd $BASE_PATH/$TDUMP_FOLDER
        echo "Gerando thread dump..."
        DATA=`date +"%Y%m%dT%H%M%S"`
        ps -eLo pcpu,pid,lwp,nlwp,ruser,stime,etime|grep $PID | sort > psResult_${TOMCAT_NAME}_${DATA}.txt
        $JAVA_HOME/bin/jstack -l $PID > dump_${TOMCAT_NAME}_${DATA}.txt

        echo "Fim da geracao do threadDump para o processo ${TOMCAT_NAME}"
}

cd $BASE_PATH
if [ ! -d "$TDUMP_FOLDER" ]; then
                echo "Diretório não encontrato. Será criado um novo..."
        mkdir $TDUMP_FOLDER
fi
