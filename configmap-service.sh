#!/bin/bash
###############################################################################
###
###    NAME / VERSION
###       configmap-service.sh    v.0.1
###
###    DESCRIPTION
###       Script to mount ConfigMaps in VMs running on KubeVirt and run the 
###       scripts provided in them.
###
###    PARAMETERS
###       None
###
###    RETURNS
###       0: OK
###       1: Error found
###       10: Script not run as Root
###       11: Usage displayed
###
###    NOTES
###
###    MODIFIED         (DD/MM/YY)
###       Red Hat       09/09/2021 - Initial cretion
###
###############################################################################


# This scripts mounts ConfigMap and runs scripts contained in it.

set -o pipefail

CONFIGMAP_DIR=/srv/configmap
CONF_DIR=/etc/configmap-service
LOGS_DIR=/var/log
LOG_FILE=${LOGS_DIR}/$(basename $0).$(date +%Y%m%d_%H%M%S).log

source ${CONF_DIR}/config

usage(){
    echo "Usage: $(basename $0) "
    echo "This script finds ConfigMaps attached to the system."
    echo "Mount ConfigMaps in $CONFIGMAP_DIR, and executes *.sh files in it."
    echo "This script must be executed by root user"
}


mount_configmap(){
    
}

run_configmap(){

}

if [ $# -ne 0 ] 
then
	usage
    exit 11
fi



if [ $(whoami) != "root" ]
then
        echo "This script must be executed by root user"
        trace_log_end 1 $@
        exit 10
fi

RC=0

echo -e "$(date) Mounting ConfigMap devices ... Logs can be found in $LOG_FILE" |tee -a $LOG_FILE
echo -e "============================================================================================\n"|tee -a $LOG_FILE
mount_configmap

echo -e "$(date) Starting ConfigMap scripts ... Logs can be found in $LOG_FILE" |tee -a $LOG_FILE
echo -e "============================================================================================\n"|tee -a $LOG_FILE
run_configmap

if [ $RC -ne 0 ]
then
	echo -e "ERROR: ConfigMap service failed to start. Logs can be found in $LOG_FILE" |tee -a $LOG_FILE
	echo -e "============================================================================================\n"|tee -a $LOG_FILE
else
	echo -e "ConfigMap service started successfully. Logs can be found in $LOG_FILE" |tee -a $LOG_FILE
	echo -e "============================================================================================\n"|tee -a $LOG_FILE
fi

exit $RC
