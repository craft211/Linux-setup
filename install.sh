#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install QEMU Guest Agent
sudo apt-get install qemu-guest-agent -y

# Start QEMU Guest Agent
systemctl start qemu-guest-agent

# Install CIFS utilities
sudo apt-get install cifs-utils -y

# Create directory for mounting
sudo mkdir /data

# Edit /etc/fstab to include CIFS mount
sudo bash -c 'echo "//10.0.0.10/data /data cifs credentials=/home/james/.smbcredentials 0 0" >> /etc/fstab'

# Create the .smbcredentials file
sudo printf "username=arrs\n\npassword=XXXX CHANGE ME XXXX!" > /home/james/.smbcredentials

# Check if the file '.smbcredential' exists in /home/james/
if [ -f "/home/james/.smbcredentials" ]; then
    echo "The file '.smbcredentials' exists in /home/james."
else
    echo "The file '.smbcredentials' does not exist in /home/james"
fi

# Set appropriate permissions for the credentials file
sudo chmod 600 /home/james/.smbcredentials

# Reload Daemon
sudo systemctl daemon-reload

# Mount the CIFS share
sudo mount /data

# Check if the folder 'media' exists in the mounted directory
if [ -d "/data/media" ]; then
    echo "The folder 'media' exists in /data."
else
    echo "The folder 'media' does not exist in /data."
fi

# Navigate to /opt/ and download Servarr install script
cd /opt/
curl -o servarr-install-script.sh https://raw.githubusercontent.com/Servarr/Wiki/master/servarr/servarr-install-script.sh
