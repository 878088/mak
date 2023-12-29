#!/bin/bash

install_azure() {
    os=$(lsb_release -i | cut -d: -f2 | sed 's/^[ \t]*//;s/[ \t]*$//')

    if [ "$os" == "Ubuntu" ] || [ "$os" == "Debian" ]; then
        sudo apt-get update -y
        sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg jq -y

        echo "检查目录是否存在"
        if [ ! -d "/etc/apt/keyrings" ]; then
            echo "目录不存在，现在创建"
            sudo mkdir -p /etc/apt/keyrings
        else
            echo "目录已存在"
        fi
        
        echo "下载并安装 Microsoft 签名密钥"
        curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
        sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

        echo "添加 Azure CLI 软件存储库"
        AZ_DIST=$(lsb_release -cs)
        echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" |
        sudo tee /etc/apt/sources.list.d/azure-cli.list

        echo "更新存储库信息并安装 Azure CLI 包"
        sudo apt-get update -y
        sudo apt-get install azure-cli -y
    else
        echo "没有适配系统"
    fi
}

login() {
    if command -v az > /dev/null 2>&1; then
        output=$(az login --use-device-code)
        if echo "$output" | jq -e . > /dev/null 2>&1; then
            echo "登录成功"
        else
            echo "登录失败，请重试"
        fi
    else
        echo "未安装 Azure CLI 请先安装"
    fi
}

menu() {
    echo "1. Install Azure CLI"
    echo "2. Login to Azure"
    echo "3. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            install_azure
            ;;
        2)
            login
            ;;
        3)
            echo "Exiting..."
            exit 1
            ;;
        *)
            echo "Invalid choice"
            menu
            ;;
    esac
}

# Call the menu function
menu
