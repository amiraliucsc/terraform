#!/bin/bash -v


LOG_FILE="/var/log/first-init.log"
START_TIME=`date`
echo "${START_TIME}: INFO: Starting init process" >> $LOG_FILE

out=$(/usr/bin/yum -y update)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to run update" >> $LOG_FILE
fi
echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success update" >> $LOG_FILE



out=$(/usr/bin/yum -y install epel-release)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to run install epel" >> $LOG_FILE
fi
echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success install epel" >> $LOG_FILE


out=$(/usr/bin/yum -y install nginx)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install Nginx" >> $LOG_FILE
fi
echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success install Nginx" >> $LOG_FILE

out=$(/usr/bin/systemctl enable nginx)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to enable Nginx" >> $LOG_FILE
fi
echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success enable Nginx" >> $LOG_FILE


out=$(/usr/bin/systemctl start nginx)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to start  Nginx" >> $LOG_FILE
fi
echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success start Nginx" >> $LOG_FILE


out=$(/usr/bin/curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install td-agent" >> $LOG_FILE
fi

out=$(/usr/bin/systemctl enable td-agent)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to enable td-agent" >> $LOG_FILE
fi
echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success enable td-agent" >> $LOG_FILE


out=$(/usr/bin/systemctl start td-agent)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to start  td-agent" >> $LOG_FILE
fi
echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Success start td-agent" >> $LOG_FILE



echo echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Finish init  process " >> $LOG_FILE
