#!/bin/bash -v


LOG_FILE="/var/log/first-init.log"
START_TIME=`date`
echo "${START_TIME}: INFO: Starting init process" >> $LOG_FILE

sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install  nginx
curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh

out=$(/usr/bin/yum -y update)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to run update" >> $LOG_FILE
fi


out=$(/usr/bin/yum -y install epel-release)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to run install epel" >> $LOG_FILE
fi


out=$(/usr/bin/yum -y install nginx)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to instll Nginx" >> $LOG_FILE
fi


out=$(/usr/bin/curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh)
ret=$?
if [[ ${ret} != 0 ]]
then
    echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): ERROR: Failed to install td-agent" >> $LOG_FILE
fi

echo echo "$(/bin/date +%Y-%m-%dT%H:%M:%S): INFO: Finish init  process " >> $LOG_FILE
