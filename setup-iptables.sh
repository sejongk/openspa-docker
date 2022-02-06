#!/bin/bash
iptables -I INPUT 1 -i lo -j ACCEPT
iptables -A INPUT -p udp --dport 22211 --jump ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables --new-chain OPENSPA
iptables --insert INPUT 3 --jump OPENSPA

iptables --new-chain OPENSPA-BLOCK
iptables --insert INPUT 4 --jump OPENSPA-BLOCK

# Here add whitelisted IP's that will have full network access to your server (eg. administrator's IP). 
# Add also (temporarly) the IP you are connecting from, to setup OpenSPA.
# iptables -A INPUT --source <WHITELIST_IP>

# If you did not properly setup the firewall this rule will block you out.
# Note, the OpenSPA server is not running yet. 
# If you won't be able to login the machine you won't be able to start the OpenSPA server.
iptables --policy INPUT DROP
