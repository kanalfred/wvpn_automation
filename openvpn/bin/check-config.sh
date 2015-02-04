
#!/bin/bash
#
# Check reuire config for opevn setup

#set -x
DIRNAME=$(dirname `readlink -f -- $0`)
# Read conf vars                                                            
source $DIRNAME/../setup.conf

#############################
#    Config Check
#############################
function check_config(){
    echo "require check"

    # Check Server primary ip address
    if ! [ -n "$ipAddress" ]; then
        #test ! -n "$ipAddress" && echo "ipAddress is not set in setup.conf, Go Away!" && exit 1
         echo "ipAddress is not setup in setup.conf, Go Away!" && exit 1
    fi

    # Check Easy RSA defualt value
    if ! [ -n "$keyCountry" ] && [ -n "keyProvince" ] && [ -n "keyCity" ] &&  [ -n "keyOrg" ] &&  [ -n "keyOrg" ]  &&  [ -n "keyEmail" ]  &&  [ -n "keyOu" ] && [ -n "keyName" ]; then
         echo "Easy RSA  is not setup in setup.conf, Go Away!" && exit 1
    fi
}

function main(){
    echo "check-config main" 
    check_config
}

main
