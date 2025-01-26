#!/bin/bash

#Update and upgrade the system
sudo apt update && sudo apt upgrade -y

#Install QEMU Guest Agent
sudo apt-get install qemu-guest-agent -y

#Start QEMU Guest Agent
systemctl start qemu-guest-agent

#Install CIFS utilities
sudo apt-get install cifs-utils -y

#Create directory for mounting
sudo mkdir /data

#Edit /etc/fstab to include CIFS mount if not already present
if ! grep -q "//10.0.0.10/data /data cifs credentials=/home/james/.smbcredentials 0 0" /etc/fstab; then
sudo bash -c 'echo "//10.0.0.10/data /data cifs credentials=/home/james/.smbcredentials 0 0" >> /etc/fstab'
echo -e "\e[32m#CIFS mount added to /etc/fstab.\e[0m"
else
echo -e "\e[32m#CIFS mount already exists in /etc/fstab.\e[0m"
fi

#Prompt user for credentials
read -p "Enter CIFS username: " cifs_username
read -sp "Enter CIFS password: " cifs_password
echo

#Create the .smbcredentials file
sudo bash -c "echo "username=$cifs_username" > /home/james/.smbcredentials"
sudo bash -c "echo "password=$cifs_password" >> /home/james/.smbcredentials"

#Check if the file '.smbcredential' exists in /home/james/
if [ -f "/home/james/.smbcredentials" ]; then
echo -e "\e[32m#The file '.smbcredentials' exists in /home/james.\e[0m"
else
echo -e "\e[32m#The file '.smbcredentials' does not exist in /home/james\e[0m"
fi

#Set appropriate permissions for the credentials file
sudo chmod 600 /home/james/.smbcredentials
sudo chown james /home/james/.smbcredentials
sudo chgrp james /home/james/.smbcredentials

#Reload Daemon
sudo systemctl daemon-reload

#Mount the CIFS share
sudo mount /data

#Check if the folder 'media' exists in the mounted directory
if [ -d "/data/media" ]; then
echo -e "\e[32m#The folder 'media' exists in /data.\e[0m"
else
echo -e "\e[32m#The folder 'media' does not exist in /data.\e[0m"
fi

#Navigate to /opt/ and download Servarr install script
cd /opt/
curl -o servarr-install-script.sh https://raw.githubusercontent.com/Servarr/Wiki/master/servarr/servarr-install-script.sh
