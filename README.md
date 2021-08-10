# forklift-configmap-service
Systemd service to run in VMs on KubeVirt to mount ConfigMaps

## Instalation

1. Copy script `configmap-service.sh` to `/usr/sbin/configmap-service.sh` 
1. Copy service file `configmap.service` to `/etc/systemd/system/configmap.service`
1. Edit service to modify `After` so it runs once the main service is started (i.e. OracleDB or PostgreSQL)
1. Reload service files `systemctl daemon-reload`
1. Assign a ConfigMap to the VM like the template provided `configmap-sample.yaml`


