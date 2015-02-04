#!/bin/bash
#
# Install require OpenVpn packages.

#set -x
DIRNAME=$(dirname `readlink -f -- $0`)
#source $DIRNAME/setup.conf

#############################
#    Install Openvpn 
#############################
function install_openvpn(){
    echo Installing openvpn
    # Todo: specify intall openvpn version
    test ! -d /etc/openvpn && sudo yum -y install openvpn bridge-utils && echo "Installed openvpn package"
    test ! -e /etc/openvpn/server.conf && sudo cp $DIRNAME../conf/server.conf /etc/openvpn/ && echo "Copied server.conf to /etc/openvpn/"
}

#############################
#    Install Easy RSA 
#############################
function install_easyrsa(){
    echo Installing easy-rsa
    test ! -d /usr/share/easy-rsa && sudo yum -y install easy-rsa && echo "Installed easy rsa package"
}

#############################
#    Install Radius plugin
#############################
function install_radius_plugin(){
    echo Installing radius plugin
    test ! -e /etc/openvpn/radiusplugin.so && cp $DIRNAME/packages/radiusplugin/radiusplugin.so /etc/openvpn/ && echo "Copied radiusplugin.so to /etc/openvpn"
    test ! -e /etc/openvpn/radiusplugin.cnf && cp $DIRNAME/packages/radiusplugin/radiusplugin.cnf /etc/openvpn/ && echo "Copied radiusplugin.cnf to /etc/openvpn"
}

function main(){
    install_openvpn
    install_easyrsa
    install_radius_plugin
}

main
