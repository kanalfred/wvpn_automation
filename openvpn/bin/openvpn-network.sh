#!/bin/bash
#
# Config Network & Firewall

#set -x
DIRNAME=$(dirname `readlink -f -- $0`)
source $DIRNAME/../setup.conf

#############################
#    Check etc path
#############################
function check_etc_path(){
    if ! [ -n "$etcPath" ]; then
        # set default if etcPath not set in setup.conf
        etcPath="/etc"
        echo "etc path is not setup in setup.conf, [$etcPath] path will be used"
    fi
}
#############################
#    Network
#############################
function config_network(){
    # Config ip fowrward
    sysctlPath="$etcPath/sysctl.conf"
    egrep -q "net.ipv4.ip_forward\s?=\s?1" "$sysctlPath" || echo "net.ipv4.ip_forward = 1" >> "$sysctlPath"
    # Restart network service
    systemctl restart network.service
}

#############################
#    Firewalld
#############################
function config_firewall(){
    # Reload firewall
    #sudo firewall-cmd --reload
    # Create zone file
    test -d "$etcPath/firewalld/zones" || mkdir -p "$etcPath/firewalld/zones"
    printf "\nCreate vpn firewalld zone\n" 
    cp "$DIRNAME/../conf/firewalld/zones/vpn.xml" "$etcPath/firewalld/zones/vpn.xml"
    # Reload firewall to pick up new added vpn.xml zone file
    sudo firewall-cmd --reload
    printf "\nRealod firewall\n" 
    # Set default zone
    firewall-cmd --set-default-zone=vpn
    printf "\nSet vpn as defualt firewalld zone\n" 
    # Add Openvpn firewall rules (we don't need the following line, since is defined in vpn.xml)
    #firewall-cmd --permanent --add-service openvpn
    #firewall-cmd --permanent --add-masquerade
}

function main(){
    printf "\n---------- CONFIG OPENVPN NETWORK ----------\n" 
    config_firewall
    config_network
}

main
