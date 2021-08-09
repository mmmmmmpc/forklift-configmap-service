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
###       12: ConfigMap mount dir doesn't exist
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
CONFIGMAP_DEVICE=$(lsblk -o NAME,FSTYPE -l | grep iso9660 | head -n 1)
CONF_DIR=/etc/configmap-service
LOGS_DIR=/var/log
LOG_FILE=${LOGS_DIR}/$(basename $0).$(date +%Y%m%d_%H%M%S).log

if [ -r ${CONF_DIR}/config ]; then
    source ${CONF_DIR}/config
fi

function usage{
    echo "Usage: configmap-service.sh"
    echo "This script finds ConfigMaps attached to the system."
    echo "Mount ConfigMaps in ${CONFIGMAP_DIR}, and executes *.sh files in it."
    echo "This script must be executed by root user"
}

function echo_log{
    echo "$1"
    echo -e "$(date) $1" >> ${LOG_FILE}
}

function mount_configmap{
if [! -d ${CONFIGMAP_DIR}]; then
    echo_log "The ${CONFIGMAP_DIR} directory to mount ConfigMap does not exist, exiting"
    exit 12
fi
if [! ${CONFIGMAP_DEVICE}]; then
    echo_log "The ${CONFIGMAP_DEVICE} device to mount ConfigMap does not exist, exiting"
fi

# Execution of the ConfigMap mount
mount -t iso9660 ${CONFIGMAP_DEVICE} ${CONFIGMAP_DIR}

if [$? -ne 0 ]; then {
    RC=$?
    echo_log "Error while mounting ${CONFIGMAP_DEVICE} on ${CONFIGMAP_DIR}"
}

run_configmap(){

}

if [ $# -ne 0 ]; then
	usage
    exit 11
fi


if [ $(whoami) != "root" ]; then
    echo_log "The $(basename) script must be executed by root user" 
        exit 10
fi

RC=0

echo_log "$(date) Mounting ConfigMap devices ... Logs can be found in ${LOG_FILE}"
echo_log "============================================================================================\n"
mount_configmap

echo_log "$(date) Starting ConfigMap scripts ... Logs can be found in ${LOG_FILE}"
echo_log "============================================================================================\n"
run_configmap

if [ $RC -ne 0 ]
then
	echo_log "ERROR: ConfigMap service failed to start. Logs can be found in ${LOG_FILE}"
	echo_log "============================================================================================\n"
else
	echo_log "ConfigMap service started successfully. Logs can be found in ${LOG_FILE}"
	echo_log "============================================================================================\n"
fi

exit $RC
