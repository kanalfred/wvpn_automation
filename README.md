# Automation
## OpenVpn
### Setup
0. yum -y install git (if git is not installed on system)
1. git clone http://git.watervpn.com/root/automation.git
2. cd automation/openvpn/
3. sudo ./setup.sh

# Prerequisites
1. Make sure has internet connection
2. Check and change ip in config 
3. Make sure firewalld is install 
   ## to install
   sudo yum install firewalld
   Remove /etc/openvpn/ccd dir
