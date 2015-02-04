#!/bin/bash
#
# Initial Setup
# 
# arg0 execute command
# arg1 first paremter

#set -x
#DIRNAME=`dirname $0`
#DIRNAME=`pwd`
DIRNAME=$(dirname `readlink -f -- $0`)
# Read conf vars                                                            
source $DIRNAME/setup.conf
#echo "$ipAddress"
# Check require config value
#test ! -n "$ipAddress" && echo "ipAddress is not set in setup.conf, Go Away!" && exit 1

#############################
#    Config Check
#############################
function check_config(){
    echo "config check"
    $DIRNAME/bin/check-config.sh
}

#############################
#    Requirement Check
#############################
function check_require(){
    echo "require check"
    #$DIRNAME/bin/check-require.sh
}

##############################
#    Setup Openvpn
##############################
function setup_openvpn(){
    echo "opevn setup"
    ## Install require packages
    #$DIRNAME/bin/openvpn-install.sh
    #
    ## Config setup 
    #ipAddress=$ipAddress $DIRNAME/bin/openvpn-config.sh
    #$DIRNAME/bin/openvpn-config.sh
    #
    ## Network setup
    #$DIRNAME/bin/openvpn-network.sh
}

function main(){
    echo "main" 
    check_config
    #check_require
    #setup_openvpn
}

main

exit 1
# Test requirement
test -z "$1" && echo "please pass in paremter" && exit 1
echo "testing $0"
