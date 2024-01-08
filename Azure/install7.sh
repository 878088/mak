#!/bin/bash

LOCATIONS=("westus3" "australiaeast" "uksouth" "southeastasia" "swedencentral" "centralus" "centralindia" "eastasia" "japaneast" "koreacentral" "canadacentral" "francecentral" "germanywestcentral" "italynorth" "norwayeast" "polandcentral" "switzerlandnorth" "brazilsouth" "northcentralus" "westus" "japanwest" "australiacentral" "canadaeast" "ukwest" "southcentralus" "northeurope" "southafricanorth" "australiasoutheast" "southindia" "uaenorth")

while true; do
    echo -e "\e[32m用户名不能包含大写字符 A-Z、特殊字符 \\/\"[]:|<>+=;,?*@#() ！或以 $ 或 - 开头\e[0m"
    echo -e "\e[32m密码长度必须在 12 到 72 之间。密码必须包含以下 3 个字符：1 个小写字符、1 个大写字符、1 个数字和 1 个特殊字符\e[0m"
    echo -e "\e[32m实例密码的特殊字符适配使用 .!@#\$%^\&*() \e[0m"
    echo -e
    read -p "请输入实例用户名: " USERNAME
    read -p "请输入实例密码: " PASSWORD
    read -p "请输入挖矿钱包: " WALLERT
    if [[ "$USERNAME" =~ [A-Z] ]]; then
        echo -e "\e[32m错误: 用户名不能包含大写字符 A-Z、特殊字符 \\/\"[]:|<>+=;,?*@#()! 或以 $ 或 - 开头\e[0m"
        continue
    fi
    PASSWORD_LENGTH=${#PASSWORD}
if [[ $PASSWORD_LENGTH -lt 12 || $PASSWORD_LENGTH -gt 72 ]]; then
    echo -e "\e[32m错误: 密码长度必须在 12 到 72 之间。\e[0m"
    continue
fi
if ! echo "$PASSWORD" | grep -q '[a-z]'; then
    echo -e "\e[32m错误: 密码必须包含至少一个小写字母。\e[0m"
    continue
fi
if ! echo "$PASSWORD" | grep -q '[A-Z]'; then
    echo -e "\e[32m错误: 密码必须包含至少一个大写字母。\e[0m"
    continue
fi
if ! echo "$PASSWORD" | grep -q '[0-9]'; then
    echo -e "\e[32m错误: 密码必须包含至少一个数字。\e[0m"
    continue
fi
if ! echo "$PASSWORD" | grep -q '[.!@#\$%^\&*()]'; then
    echo -e "\e[32m错误: 密码必须包含至少一个特殊字符。\e[0m"
    continue
fi
    echo -e
    echo -e "\e[32m用户名和密码验证成功\e[0m"
    break
done
declare -a pids
for location in "${LOCATIONS[@]}"; do
    groupInfo=$(az group show --name "$location" 2>&1)
    if [ $? -eq 0 ]; then
        echo -e "\e[33m资源组已存在 $location\e[0m"
    else
        errorMessage=$(echo "$groupInfo" | grep -oP "(?<=Message:\s).+")
        az group create --name "$location" --location "$location"
        if [ $? -eq 0 ]; then
            echo -e "\e[32m资源组创建成功 $location\e[0m"
            nohup az vm create --resource-group "$location" --name "$location" --location "$location" --image Debian11 --size Standard_DS12_v2 --admin-username "$USERNAME" --admin-password "$PASSWORD" --security-type Standard --public-ip-sku Basic --public-ip-address-allocation Dynamic > /dev/null 2>&1 &
            pid=$!
            pids+=($pid)
            echo -e "\e[36m已在后台执行 az vm create 命令\e[0m"
        else
            echo -e "\e[31m资源组创建失败 $location\e[0m"
            echo -e "\e[31m$errorMessage\e[0m"
        fi
    fi
done

for pid in "${pids[@]}"; do
    wait $pid
    if [ $? -eq 0 ]; then
        echo -e "\e[32mVM创建成功$location\e[0m"
    else
        echo -e "\e[31mVM创建失败$location\e[0m"
    fi
done
ips=$(az network public-ip list --query "[].ipAddress" -o tsv)
for ip in $ips; do
  {
    nohup sshpass -p "$PASSWORD" ssh -tt -o StrictHostKeyChecking=no $USERNAME@$ip 'sudo bash -c "curl -s -L https://raw.githubusercontent.com/878088/zeph/main/setup_zeph_miner.sh | LC_ALL=en_US.UTF-8 bash -s '$WALLERT'"' && echo -e "\e[32m$ip 成功链接 SSH 执行挖矿成功\e[0m"
  } &
done
