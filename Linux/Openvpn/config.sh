#!/bin/bash

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

sudo apt-get install openvpn
sudo cp ./VPNMakers.cer.pem /etc/openvpn
sudo cp ./VPNMakers.ca.pem /etc/openvpn
sudo cp ./VPNMakers.key.pem /etc/openvpn
sudo cp ./client.conf /etc/openvpn
sudo cp ./userpass /etc/openvpn
sudo cp ./startVPN /usr/bin
sudo cp ./stopVPN /usr/bin

confirm "Do you want to put your password into userpass file now?" && sudo vim /etc/openvpn/userpass

echo "Openvpn successfully installed! If you want to change the configs, edit /etc/openvpn/userpass."

