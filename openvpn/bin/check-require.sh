
#!/bin/bash
#
# Requirement Check

#set -x
DIRNAME=$(dirname `readlink -f -- $0`)
# Read conf vars                                                            
source $DIRNAME/../setup.conf

#############################
#    OS Check
#############################
function check_os(){
    # Check Centos release file exist
    test ! -f /etc/centos-release && echo "OpenVpn script only support centos platform" && exit 1

    # Check Centos version - expect "CentOS Linux release 7.0.1406 (Core)"
    CENTOS_VERSION=`cat /etc/centos-release`
    if ! [[ $CENTOS_VERSION =~ ^CentOS[[:space:]]Linux[[:space:]]release[[:space:]]7.* ]]; then
        echo 'OpenVpn script only support centos version 7, go away!' && exit 1
    fi
    echo "OS Check Passed!"
}

#############################
#    Internet Check
#############################
function check_internet(){
    # Check internet connection
    wget -q --tries=10 --timeout=20 --spider http://google.com
    # $? find error code of last execute command
    if ! [[ $? -eq 0 ]]; then
        echo "No internet connection, go away!" && exit 1
    fi
    echo "Interent Check Passed!"
}

#############################
#    Repo Check
#############################
function check_repo(){
    # Check EPEL repo
    EPEL=`yum repolist epel | grep epel`
    if [ -z "$EPEL" ]; then
        echo "EPEL repo is not install, EPEL installing started"
        # Install epel from repo
        ##wget -O /tmp/epel-release-7-5.noarch.rpm http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
        # Install epel form directry
        sudo yum -y install $DIRNAME/../packages/repo/epel-release-7-5.noarch.rpm
    fi
    echo "Repo Check Passed!"
}

#############################
#    Package Check
#############################
function check_package(){
    # Check requirment packages 
    test ! -f `which wget` && sudo yum -y install wget && echo "Installng missing wget package"
    test ! -f `which git` && sudo yum -y install git && echo "Installing missing git package"
    echo "Package Check Passed!"
}

function main(){
    printf "\n---------- CHECK REQUIREMENT ----------\n" 
    check_os
    check_internet
    check_repo
    check_package
}

main
