#!/bin/sh

umask 002

VPN_GW=$(/sbin/ip route | awk '/default/ { print $3 }')
echo Saving gate $VPN_GW 
echo DELETING DEFAULT GW
ip route del default
echo SETTING $VPN_IP as the only ip to get routed through $VPN_GW 
ip route add $VPN_IP via $VPN_GW
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo Starting openvpn
ip route
cd /vpn

until openvpn vpn; do
    echo "Openvpn crashed, respawning"
    sleep 10
done 
