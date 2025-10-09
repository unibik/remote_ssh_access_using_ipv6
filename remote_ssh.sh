#!/bin/bash

#Bash script to setup remote ssh access using IPv6
#Author : unibik

#To run this script, it need root previleges. so be sure to run as a root user.

#checking for root previleges.
if [ "$EUID" -ne 0 ]; then
    echo "Permission denied, please run as a root."
    echo "e.g. sudo ./yourfilename.sh"
    exit
fi

echo "🚀 Installing OpenSSH-server.............."
apt update && apt install openssh-server -y
echo "✅ OpenSSH-server installed successfully."

echo "🔧 Enabling SSH Services"
systemctl enable ssh
systemctl start ssh

echo "let us modify sshd_config file"
CONFIG=/etc/ssh/sshd_config

sed -i 's/#\?PasswardAuthentication.*/PasswordAuthentication yes/' $CONFIG
sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' $CONFIG
sed -i 's/#\?AddressFamily.*/AddressFamily inet6/' $CONFIG

echo "🔄 Restarting SSH service to apply changes"
systemctl restart ssh

#Fetch IPv6 address
IPV6=$(ip -6 addr show scope global | grep inet6 | awk '{print$2}' | cut -d/ -f1 | head -n1)

echo ""
echo "🎉 SSH setup is complete!"
echo "-------------------------------"
echo "🌏 your global IPv6 is: $IPV6"
echo "connect using: "
echo "ssh -6 root@$IPV6"
echo "-------------------------------"
echo "hurray! Now you can access this machine remotely using IPv6 address."