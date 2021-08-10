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
###       2: Install path not a dir
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
    echo "Usage: configmap-service-install.sh [<install_path>|--help]"
    echo "This script installs configmap-service in the system."
    echo "This script must be executed by root user"
}

function echo_log {
    echo "$1"
    echo -e "$(date) $1" >> ${LOG_FILE}
}

if [ $# -ne 0 ]; then
    if [ "$1" = "--help" ]; then
    	usage
        exit 0
    else
        INSTALL_PATH=$1
        if [ ! -d ${INSTALL_PATH} ]; then
            echo_log "Install path not an existing directory. Exiting"
            exit 2
        fi
    fi
else
    echo_log "No install path provided, using defaults" 
    INSTALL_PATH=""
fi

if [ $(whoami) != "root" ]; then
    echo_log "The $(basename) script must be executed by root user" 
        exit 1
fi

echo_log "$(date) Copying files ... Logs can be found in ${LOG_FILE}"
echo_log "============================================================================================\n"

for REQUIRED_DIRS in "/usr/sbin/ /etc/systemd/system/"; do
   if [ ! -d "${REQUIRED_DIRS}" ]; then
      mkdir -v -p ${REQUIRED_DIRS} | tee ${LOG_FILE}
   fi 
done

/usr/bin/cp -vf ./configmap-service.sh ${INSTALL_PATH}/usr/sbin/configmap-service.sh | tee ${LOG_FILE}
/usr/bin/chmod -v 755 ${INSTALL_PATH}/usr/sbin/configmap-service.sh | tee ${LOG_FILE}
/usr/bin/cp -vf ./configmap.service ${INSTALL_PATH}/etc/systemd/system/configmap.service | tee ${LOG_FILE}
/usr/bin/chmod -v 644 /etc/systemd/system/configmap.service | tee ${LOG_FILE}

if [ $# -eq 0 ]; then
    /usr/bin/systemctl daemon-reload
    /usr/bin/systemctl enable configmap
fi
