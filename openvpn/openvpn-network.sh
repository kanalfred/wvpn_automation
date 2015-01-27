#!/bin/bash
#
# Config Network & Firewall

#set -x
DIRNAME=`dirname $0`

#######################################
#    Network
#######################################

#######################################
#    Firewalld
#######################################
#firewall-cmd --permanent --add-service openvpn
#firewall-cmd --permanent --add-masquerade

#######################################
# Cleanup files from the backup dir
# Globals:
#   BACKUP_DIR
#   ORACLE_SID
# Arguments:
#   None
# Returns:
#   None
# Url: https://google-styleguide.googlecode.com/svn/trunk/shell.xml#Comments
#######################################
