# forklift-configmap-service
Systemd service to run in VMs on KubeVirt to mount ConfigMaps

## Installation
The script `configmap-service-install.sh` can be used to install `configmap-service`.
To install it in a Linux system with `systemd`simply run

    ./configmap-service-install.sh

This will copy the script, install the service, apply correct permissions, reload `systemd` and leave it ready to run.

In case you want to package it and install it somewhere else, you can pass a target folder to it

    ./configmap-service-install.sh /tmp

Then it will just copy the files to the target folders, recreating the relative paths. (Useful for packaging)

## Installation in Red Hat Enterprise Linux 8 (RHEL8)
To install the service in different RPM based distros, there is a (Forkift ConfigMap Service Repo)[https://copr.fedorainfracloud.org/coprs/mperezco/forklift-configmap-service/] Avalable. To make things easy a repo file is provided for RHEL8 users `mperezco-forklift-configmap-service-epel-8.repo`. To use it follow these steps:

    cp mperezco-forklift-configmap-service-epel-8.repo /etc/yum.repos.d/
    yum install configmap-service -y


## Manual Instalation

1. Copy script `configmap-service.sh` to `/usr/sbin/configmap-service.sh` 
1. Copy service file `configmap.service` to `/etc/systemd/system/configmap.service`
1. Edit service to modify `After` so it runs once the main service is started (i.e. OracleDB or PostgreSQL)
1. Reload service files `systemctl daemon-reload`
1. Assign a ConfigMap to the VM like the template provided `configmap-sample.yaml`

## Configuration
The `configmap-service` is intended to be run after the main service in the VM is running (i.e. a Database) so it can apply changes to it.
A default configuration is provided and deployed to `/etc/systemd/system/configmap.service` in command line installations and to `/var/lib/systemd/system/configmap.service` in RPM based installations.

To customize the starting up of the service, we shall edit `/etc/systemd/system/configmap.service`, which for RPM based installations means copying the file under `/var/lib/systemd` there and then editing it.

The parameter to be changed is `After` under `[Unit]`. The default is set to run after `network.target`:

    After=network.target

In case we are running a PostgreSQL service we may change that line to:

    After=postgresql.service

This way, the service will run once the database is active and we can perform actions such as preload data to it from our ConfigMap, Label it as DEV/TEST/PROD or even change the database schema.

For any comments mail to forklift-dev@googlegroups.com 

