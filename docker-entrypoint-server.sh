#!/bin/bash

# set echo ip server in config
#ECHO_IP=172.17.0.2:8080
#sed -i "s/^echoIpv4Server:.*/echoIpv4Server: http:\/\/$ECHO_IP/" ./config.yaml
#sed -i "s/^echoIpv6Server:.*/echoIpv6Server: http:\/\/$ECHO_IP/" ./config.yaml
#echo "Successfully set echo ip server in config"

# set iptables
./setup-iptables.sh
# apt install iptables-persistent
echo "Successfully set iptables rules"

./openspa-server start -c ./config.yaml $@
