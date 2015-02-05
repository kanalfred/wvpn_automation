
#!/bin/bash
#
# Config & Setup OpenVpn.

#set -x
#DIRNAME=`dirname $0`
DIRNAME=$(dirname `readlink -f -- $0`)
source $DIRNAME/../setup.conf

#############################
#    Server.conf 
#############################
function config_openvpn(){
    #test ! -e /etc/openvpn/server.conf && sudo cp $DIRNAME/conf/server.conf /etc/openvpn/ && echo "Copied server.conf to /etc/openvpn/"
    # find and replace %server-ip% in server.conf
    serverConfPath="$DIRNAME/../conf/server-test.conf"

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
    # delete easeyRsaPath to reconfig
    #easeyRsaPath="/etc/openvpn/easy-rsa"
    easeyRsaPath="$DIRNAME/../test-etc/openvpn/easy-rsa"
  # #if [ ! -d "$easeyRsaPath/keys" ]; then
        echo "Copy easy RSA key libs to $easeyRsaPath"

        mkdir -p "$easeyRsaPath/keys" 
        # copy easy-ras bin file to /etc/openvpn/ for generate ras keys
        cp -rf /usr/share/easy-rsa/2.0/* $easeyRsaPath

        # copy prepared easy-rsa var template 
        yes | cp $DIRNAME/../conf/vars $easeyRsaPath/vars
  # #fi

    # Edit easy-ras default value for generate keys in /etc/openvpn/easy-rsa/var 
    if [ -e "$easeyRsaPath/vars" ]; then
        sed -i "s/%key-country%/$keyCountry/g" "$easeyRsaPath/vars"
        sed -i "s/%key-province%/$keyProvince/g" "$easeyRsaPath/vars"
        sed -i "s/%key-city%/$keyCity/g" "$easeyRsaPath/vars"
        sed -i "s/%key-org%/$keyOrg/g" "$easeyRsaPath/vars"
        sed -i "s/%key-email%/$keyEmail/g" "$easeyRsaPath/vars"
        sed -i "s/%key-ou%/$keyOu/g" "$easeyRsaPath/vars"
        sed -i "s/%key-name%/$keyName/g" "$easeyRsaPath/vars"
       echo "Done! Config Easy RAS" 
    fi   

    #Todo copy_ca_key
    generate_easyras_key
}

function generate_easyras_key(){
    echo "asdfasdf"
    # generate_server_key
    # generate_hd_key
}

#############################
#    Radius Plugin
#############################
function config_radius_plugin(){
    echo "asfasdf"
    # add client-config-dir ccd to sever.conf
    # mkdir /etc/openvpn/ccd
    # sed openvpn-config.sh change ip address
    #remove radiusLine in sever & sed server.conf change ip address to include radius plugin
}

function main(){
    printf "\n---------- CONFIGING OPENVPN ----------\n" 
    config_openvpn
    config_easyras
}

main
