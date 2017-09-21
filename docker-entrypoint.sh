#!/bin/bash

# Update HOST with actual value, uniquely generated by Docker on each start
sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/listener.ora
sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/tnsnames.ora

pmon=`ps -ef | grep pmon_$ORACLE_SID | grep -v grep`
if [ "$pmon" == "" ]; then
    date
    /etc/init.d/oracle-xe start
fi

sqlplus -l sys/3p0ldb as sysdba @/create-users.sql
tail -f /u01/app/oracle/admin/XE/dpdump/dp.log