
#!/bin/bash
#
# Config & Setup OpenVpn.

#set -x
#DIRNAME=`dirname $0`
DIRNAME=$(dirname `readlink -f -- $0`)
source $DIRNAME/../setup.conf

#############################
#    Check etc path
#############################
function check_etc_path(){
    if ! [ -n "$etcPath" ]; then
        # set default if etcPath not set in setup.conf
        etcPath="/etc"
        echo "etc path is not setup in setup.conf, [$etcPath] path will be used"
    fi
}

#############################
#    Server.conf 
#############################
function config_openvpn(){
    # server.conf template path
    serverConfTemplatePath="$DIRNAME/../conf/openvpn/server.conf"
    serverConfPath="$etcPath/openvpn"

    # copy server.conf template
    sudo yes | cp $serverConfTemplatePath $serverConfPath/ && echo "Copy $serverConfTemplatePath to $serverConfPath"

    # find and replace %server-ip% in server.conf
    if [ -n "$ipAddress" ] && [ -e "$serverConfPath/server.conf" ]; then
        echo "$serverConfPath ip address updated to: $ipAddress"
        sed -i "s/%server-ip%/$ipAddress/g" "$serverConfPath/server.conf"
    else
        echo "$serverConfPath/server.conf ip address is NOT updated, missing ipAddress or can't find server.conf file"
    fi
}

#############################
#    Key & Cert Generation
#############################
function config_easyras(){
    easyRsaPath="$etcPath/openvpn/easy-rsa"
    openvpnPath="$etcPath/openvpn"

  # #if [ ! -d "$easyRsaPath/keys" ]; then
        echo "Copy easy RSA key libs to $easyRsaPath"

        mkdir -p "$easyRsaPath/keys" 
        # copy easy-ras bin file to /etc/openvpn/ for generate ras keys
        cp -rf /usr/share/easy-rsa/2.0/* $easyRsaPath

        # copy easy-rsa var template 
        yes | cp $DIRNAME/../conf/easy-rsa/vars $easyRsaPath/vars
  # #fi

    # Edit easy-ras default value for generate keys in /etc/openvpn/easy-rsa/var 
    if [ -e "$easyRsaPath/vars" ]; then
        sed -i "s/%key-country%/$keyCountry/g" "$easyRsaPath/vars"
        sed -i "s/%key-province%/$keyProvince/g" "$easyRsaPath/vars"
        sed -i "s/%key-city%/$keyCity/g" "$easyRsaPath/vars"
        sed -i "s/%key-org%/$keyOrg/g" "$easyRsaPath/vars"
        sed -i "s/%key-email%/$keyEmail/g" "$easyRsaPath/vars"
        sed -i "s/%key-ou%/$keyOu/g" "$easyRsaPath/vars"
        sed -i "s/%key-name%/$keyName/g" "$easyRsaPath/vars"
        echo "Done! Config Easy RAS" 
    fi   

    # Prepare Generate Easy RAS Env & default Easy RAS values
    cd $easyRsaPath 
    source ./vars
    yes | source ./clean-all

    # Generate & Config easyras keys
    # Function Call config_easyras_keys
    config_easyras_keys
}

function config_easyras_keys(){
    config_ca_key
    config_server_key
    config_hd_key
    # we don't need generate client key here, we will have Websever to generate client key on the fly
}

function config_ca_key(){
    # Copy Ca keys template
    # We don't need to copy ca.key private we only need ca.crt
    yes | cp $DIRNAME/../keys/ca.crt $easyRsaPath/keys/
    yes | cp $DIRNAME/../keys/ca.key $easyRsaPath/keys/
    yes | cp $DIRNAME/../keys/ca.crt $openvpnPath
    echo "Done! Copy ca keys to [$easyRsaPath/keys/]" 
}

function config_server_key(){
    cd $easyRsaPath 
    # generate_server_key add --batch that won't intract ask user from input
    ./build-key-server --batch server
    yes | cp $easyRsaPath/keys/server.crt $openvpnPath
    yes | cp $easyRsaPath/keys/server.key $openvpnPath
    echo "Done! Generated new [server] keys and Copy them to [$easyRsaPath/keys/]" 
}

function config_hd_key(){
    cd $easyRsaPath 
    # generate_hd_key
    ./build-dh
    yes | cp $easyRsaPath/keys/dh2048.pem $openvpnPath
}

#############################
#    Radius Plugin
#############################
function config_radius_plugin(){
    yes | cp $DIRNAME/../conf/radiusplugin/radiusplugin.cnf $openvpnPath/ && echo "Copy radiusplugin.cnf to $openvpnPath/"

    # Edit radius plugin config in /etc/openvpn/radiusplugin.cnf 
    if [ -e "$openvpnPath/radiusplugin.cnf" ]; then
        sed -i "s/%server-ip%/$ipAddress/g" "$openvpnPath/radiusplugin.cnf"
        sed -i "s/%radiusAcctport%/$radiusAcctport/g" "$openvpnPath/radiusplugin.cnf"
        sed -i "s/%radiusAuthport%/$radiusAuthport/g" "$openvpnPath/radiusplugin.cnf"
        sed -i "s/%radiusIpAddress%/$radiusIpAddress/g" "$openvpnPath/radiusplugin.cnf"
        sed -i "s/%radiusSharedsecret%/$radiusSharedsecret/g" "$openvpnPath/radiusplugin.cnf"
        echo "Done! Config radius plugin" 
    fi   

    #remove radiusLine in sever & sed server.conf change ip address to include radius plugin
    # add client-config-dir ccd to sever.conf
    egrep -q "^client-config-dir\s?ccd" "$openvpnPath/server.conf" || echo "client-config-dir ccd" >> "$openvpnPath/server.conf"

    # mkdir /etc/openvpn/ccd
    test ! -d $openvpnPath/ccd && mkdir $openvpnPath/ccd && echo "Creating ccd dir under $openvpnPath/"
}

#############################
#    Enable Service
#############################
function enable_service(){
    # Register as service
    systemctl -f enable openvpn@server.service
    # Start servcie
    systemctl start openvpn@server.service
    echo "Started Openvpn@server.service\n" 
}

function main(){
    printf "\n---------- CONFIGING OPENVPN ----------\n" 
    check_etc_path
    config_openvpn
    config_easyras
    config_radius_plugin
    enable_service
}

main
