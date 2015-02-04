
#!/bin/bash
#
# Config & Setup OpenVpn.

#set -x
#DIRNAME=`dirname $0`
DIRNAME=$(dirname `readlink -f -- $0`)
source $DIRNAME/setup.conf

#############################
#    Server.conf 
#############################
function config_openvpn(){
    test ! -e /etc/openvpn/server.conf && sudo cp $DIRNAME/conf/server.conf /etc/openvpn/ && echo "Copied server.conf to /etc/openvpn/"
    # find and replace %server-ip% in server.conf
    serverConfPath="$DIRNAME/conf/server-test.conf"

    if [ -n "$ipAddress" ] && [ -e "$serverConfPath" ]; then
        echo "$serverConfPath ip address updated to: $ipAddress"
        #sed -i "s/%server-ip%/$serverIp/g" "$serverConfPath"
    else
        echo "$serverConfPath ip address is NOT updated, missing ipAddress or can't find server.conf file"
    fi
}

#############################
#    Key & Cert Generation
#############################
function config_easyras(){
    # copy easy-ras bin file to /etc/openvpn/ for generate ras keys
    easeyRsaPath="/etc/openvpn/easy-rsa"
    if [ ! -d "$easeyRsaPath/keys" ]; then
        mkdir -p "$easeyRsaPath/keys" 
        cp -rf "/usr/share/easy-rsa/2.0/* $easeyRsaPath"
    fi

    # copy prepared easy-rsa var template 
    yes | cp $DIRNAME/conf/vars /etc/openvpn/easy-rsa/vars

    # Edit easy-ras default value for generate keys in /etc/openvpn/easy-rsa/var 
    if [ -e "$easeyRsaPath/var" ]; then
        #sed -i "s/%server-ip%/$serverIp/g" "$serverConfPath"
       echo "ateate" 
    fi   
}

#############################
#    Radius Plugin
#############################
function config_easyras(){
    echo "asfasdf"
}

function main(){
    config_openvpn
}

main
