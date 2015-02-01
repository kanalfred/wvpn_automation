#!/bin/bash
#
# Initial Setup
# 
# arg0 execute command
# arg1 first paremter

#set -x
DIRNAME=`dirname $0`

#############################
#    Read setup config
#############################
# Read conf vars                                                            
source $DIRNAME/setup.conf
echo "$ipAddress"
# Check require config value
test ! -n "$ipAddress" && echo "ipAddress is not set in setup.conf, Go Away!" && exit 1

#############################
#    Requirement Check
#############################
#$DIRNAME/require-check.sh
#
##############################
##    Setup Openvpn
##############################
## Install require packages
#$DIRNAME/openvpn-install.sh
#
## Config setup 
ipAddress=$ipAddress $DIRNAME/openvpn-config.sh
#
## Network setup
#$DIRNAME/openvpn-network.sh

exit 1
# Test requirement
test -z "$1" && echo "please pass in paremter" && exit 1
echo "testing $0"
