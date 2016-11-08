#!/bin/bash

serverIP="localhost"
port="3142"

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


echo "Acquire::http::Proxy \"http://$serverIP:$port\";" | sudo tee /etc/apt/apt.conf

echo "Ready to use apt-cacher-ng!"

confirm "you want to run apt-get update now?(y/N)" && sudo apt-get update
