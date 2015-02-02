
#!/bin/bash
#
# Config & Setup OpenVpn.

#set -x
DIRNAME=`dirname $0`

#############################
#    Server.conf 
#############################
# find and replace %server-ip% in server.conf
serverConfPath="$DIRNAME/conf/server-test.conf"

if [ -n "$ipAddress" ] && [ -e "$serverConfPath" ]; then
    echo "$serverConfPath ip address updated to: $ipAddress"
    #sed -i "s/%server-ip%/$serverIp/g" "$serverConfPath"
else
    echo "$serverConfPath ip address is NOT updated, missing ipAddress or can't find server.conf file"
fi

#############################
#    Key & Cert Generation
#############################
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


#############################
#    Radius Plugin
#############################
