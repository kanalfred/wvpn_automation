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
    # Todo: specify intall openvpn version
    test ! -d /etc/openvpn && sudo yum -y install openvpn bridge-utils && echo "Installing openvpn package ..."
    #test ! -e /etc/openvpn/server.conf && sudo cp $DIRNAME../conf/openvpn/server.conf /etc/openvpn/ && echo "Copy server.conf to /etc/openvpn/"
    echo "Done! installed OpenVpn package"
}

#############################
#    Install Easy RSA 
#############################
function install_easyrsa(){
    test ! -d /usr/share/easy-rsa && sudo yum -y install easy-rsa && echo "Installing easy rsa package"
    echo "Done! installed Easy-RSA package"
}

#############################
#    Install Radius plugin
#############################
function install_radius_plugin(){
    test ! -e /etc/openvpn/radiusplugin.so && cp $DIRNAME/packages/radiusplugin/radiusplugin.so /etc/openvpn/ && echo "Copy radiusplugin.so to /etc/openvpn"
    #test ! -e /etc/openvpn/radiusplugin.cnf && cp $DIRNAME/packages/radiusplugin/radiusplugin.cnf /etc/openvpn/ && echo "Copy radiusplugin.cnf to /etc/openvpn"
    echo "Done! installed OpenVpn Radius plugin apackage"
}

function main(){
    printf "\n---------- INSTALL OPENVPN PACKAGE ----------\n" 
    install_openvpn
    install_easyrsa
    install_radius_plugin
}

main
