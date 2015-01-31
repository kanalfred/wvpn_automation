#!/bin/bash
#
# Initial Setup
# 
# arg0 execute command
# arg1 first paremter

#set -x
DIRNAME=`dirname $0`

#############################
#    Requirement Check
#############################
$DIRNAME/require-check.sh


#############################
#    Setup Openvpn
#############################
# Install require packages
$DIRNAME/openvpn-install.sh

# Config setup 
$DIRNAME/openvpn-config.sh

# Network setup
$DIRNAME/openvpn-network.sh

exit 1
# Test requirement
test -z "$1" && echo "please pass in paremter" && exit 1
echo "testing $0"
