#!/bin/bash

os=$(lsb_release -i | cut -d: -f2 | sed 's/^[ \t]*//;s/[ \t]*$//')

if [ "$os" == "Ubuntu" ] || [ "$os" == "Debian" ]; then
    echo "This is Ubuntu or Debian"
    echo "Checking if directory exists..."
    if [ ! -d "/etc/apt/keyrings" ]; then
        echo "Directory does not exist. Creating now..."
        sudo mkdir -p /etc/apt/keyrings
    else
        echo "Directory already exists."
    fi
    echo "Installing key..."
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

    echo "Adding Azure CLI repository..."
    AZ_DIST=$(lsb_release -cs)
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

    echo "Updating package lists..."
    sudo apt-get update

    echo "Installing Azure CLI..."
    sudo apt-get install azure-cli
else
    echo "This is not Ubuntu or Debian"
fi
