#!/usr/bin/bash
/usr/bin/mysql --silent -e "SELECT ID, db, host, STATE, Time, SUBSTRING(Info,1,100) FROM information_schema.PROCESSLIST WHERE Command NOT IN ('Sleep') ORDER BY Time DESC"

