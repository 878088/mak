#!/bin/bash

os=$(lsb_release -i | cut -d: -f2 | sed 's/^[ \t]*//;s/[ \t]*$//')

if [ "$os" == "Ubuntu" ] || [ "$os" == "Debian" ]; then
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y

    echo "检查目录是否存在..."
    if [ ! -d "/etc/apt/keyrings" ]; then
        echo "目录不存在。现在创建..."
        sudo mkdir -p /etc/apt/keyrings
    else
        echo "目录已存在."
    fi
    
    echo "下载并安装 Microsoft 签名密钥..."
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

    echo "添加 Azure CLI 软件存储库..."
    AZ_DIST=$(lsb_release -cs)
    echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

    echo "更新存储库信息并安装 azure-cli 包..."
    sudo apt-get update -y
    sudo apt-get install azure-cli -y
else
    echo "This is not Ubuntu or Debian"
fi
