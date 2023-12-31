#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

install_azure() {
    os=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')

    if [ "$os" == "ubuntu" ] || [ "$os" == "debian" ]; then
        sudo apt-get update -y
        sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg jq sshpass screen -y

        if [ ! -d "/etc/apt/keyrings" ]; then
            echo -e "${RED}目录不存在，现在创建${NC}"
            sudo mkdir -p /etc/apt/keyrings
        else
            echo -e "${GREEN}目录已存在${NC}"
        fi
        
        echo -e "${GREEN}下载并安装 Microsoft 签名密钥${NC}"
        curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
        sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

        echo -e "${GREEN}添加 Azure CLI 软件存储库${NC}"
        AZ_DIST=$(lsb_release -cs)
        echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" |
        sudo tee /etc/apt/sources.list.d/azure-cli.list

        echo -e "${GREEN}更新存储库信息并安装 Azure CLI 包${NC}"
        sudo apt-get update -y
        sudo apt-get install azure-cli -y
    else
        echo -e "${RED}没有适配系统${NC}"
    fi
    menu
}

login() {
    if command -v az > /dev/null 2>&1; then
        output=$(az login --use-device-code)
        if echo "$output" | jq -e . > /dev/null 2>&1; then
            echo -e "${GREEN}登录成功${NC}"
        else
            echo -e "${RED}登录失败，请重试${NC}"
        fi
    else
        echo -e "${RED}未安装 Azure CLI 请先安装${NC}"
    fi
    menu
}

menu() {
    echo -e "${GREEN}1. 安装 Azure CLI${NC}"
    echo -e "${GREEN}2. 登录 Azure CLI${NC}"
    echo -e "${GREEN}0. 退出${NC}"
    read -p "输入您的选择: " choice

    case $choice in
        1)
            install_azure
            ;;
        2)
            login
            ;;
        0)
            echo -e "${RED}退出...${NC}"
            exit 1
            ;;
        *)
            echo -e "${RED}选择无效${NC}"
            menu
            ;;
    esac
}

menu
