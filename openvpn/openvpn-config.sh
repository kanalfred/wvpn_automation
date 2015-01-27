#!/bin/bash
#
# Perform hot backups of Oracle databases.

#set -x
DIRNAME=`dirname $0`

#############################
#    Server.conf 
#############################
# find and replace %server-ip%
serverConfPath="$DIRNAME/conf/server-test.conf"
serverIp="198.50.156.37"
echo "$serverConfPath ip address updated to: $serverIp"
#sed -i "s/%server-ip%/$serverIp/g" "$serverConfPath"

#############################
#    Key & Cert Generation
#############################

#test ! -d /usr/share/easy-rsa && yum -y install easy-rsa
#mkdir -p /etc/openvpn/easy-rsa/keys
#cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa


#############################
#    Radius Plugin
#############################
