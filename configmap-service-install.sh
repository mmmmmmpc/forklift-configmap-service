#!/bin/bash
###############################################################################
###
###    NAME / VERSION
###       configmap-service-install.sh    v.0.1
###
###    DESCRIPTION
###       Script to install the configmap-service
###
###    PARAMETERS
###       None
###
###    RETURNS
###       0: OK
###       1: Error found
###
###    NOTES
###
###    MODIFIED         (DD/MM/YY)
###       Red Hat       10/09/2021 - Initial cretion
###
###############################################################################

set -o pipefail

LOGS_DIR=/var/log
LOG_FILE=${LOGS_DIR}/$(basename $0).$(date +%Y%m%d_%H%M%S).log

function usage {
    echo "Usage: configmap-service-install.sh"
    echo "This script installs configmap-service in the system."
    echo "This script must be executed by root user"
}

function echo_log {
    echo "$1"
    echo -e "$(date) $1" >> ${LOG_FILE}
}

if [ "$1" = "--help" ]; then
	usage
    exit 0
fi


if [ $(whoami) != "root" ]; then
    echo_log "The $(basename) script must be executed by root user" 
        exit 1
fi

echo_log "$(date) Copying files ... Logs can be found in ${LOG_FILE}"
echo_log "============================================================================================\n"

cp ./configmap-service.sh  /usr/sbin/configmap-service.sh
chmod 755 /usr/sbin/configmap-service.sh
cp ./configmap.service /etc/systemd/system/configmap.service
chmod 644 /etc/systemd/system/configmap.service
systemctl daemon-reload

