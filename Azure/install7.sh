#!/bin/bash
LOCATIONS=("westus3" "australiaeast" "uksouth" "southeastasia" "swedencentral" "centralus" "centralindia" "eastasia" "japaneast" "koreacentral" "canadacentral" "francecentral" "germanywestcentral" "italynorth" "norwayeast" "polandcentral" "switzerlandnorth" "brazilsouth" "northcentralus" "westus" "japanwest" "australiacentral" "canadaeast" "ukwest" "southcentralus" "northeurope" "southafricanorth" "australiasoutheast" "southindia" "uaenorth")
while true; do
    allGroupsCreated=true    
    for location in "${LOCATIONS[@]}"; do
        if az group exists --name "$location" &>/dev/null; then
            echo -e "\e[33m资源组已存在 $location\e[0m"
        else
            az group create --name "$location" --location "$location"
            if [ $? -eq 0 ]; then
                echo -e "\e[32m资源组创建成功 $location\e[0m"
            else
                echo -e "\e[31m资源组创建失败 $location\e[0m"
                allGroupsCreated=false
            fi
        fi
    done    
    if $allGroupsCreated; then
        break
    fi
done
