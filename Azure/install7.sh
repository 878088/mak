#!/bin/bash

LOCATIONS=("westus3" "australiaeast" "uksouth" "southeastasia" "swedencentral" "centralus" "centralindia" "eastasia" "japaneast" "koreacentral" "canadacentral" "francecentral" "germanywestcentral" "italynorth" "norwayeast" "polandcentral" "switzerlandnorth" "brazilsouth" "northcentralus" "westus" "japanwest" "australiacentral" "canadaeast" "ukwest" "southcentralus" "northeurope" "southafricanorth" "australiasoutheast" "southindia" "uaenorth")

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
            nohup az vm create --resource-group "$location" --name "$location" --location "$location" --image Debian11 --size Standard_DS12_v2 --admin-username ooo --admin-password KKKKjjjj520. --security-type Standard --public-ip-sku Basic --public-ip-address-allocation Dynamic > /dev/null 2>&1 &
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
        echo -e "\e[32mVM 创建成功\e[0m"
    else
        echo -e "\e[31mVM 创建失败\e[0m"
    fi
done
