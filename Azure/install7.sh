#!/bin/bash

LOCATIONS=("westus3" "australiaeast" "uksouth" "southeastasia" "swedencentral" "centralus" "centralindia" "eastasia" "japaneast" "koreacentral" "canadacentral" "francecentral" "germanywestcentral" "italynorth" "norwayeast" "polandcentral" "switzerlandnorth" "brazilsouth" "northcentralus" "westus" "japanwest" "australiacentral" "canadaeast" "ukwest" "southcentralus" "northeurope" "southafricanorth" "australiasoutheast" "southindia" "uaenorth")

while true; do
    allGroupsCreated=true
    
    for location in "${LOCATIONS[@]}"; do
        groupInfo=$(az group show --name "$location" 2>&1)
        if [ $? -eq 0 ]; then
            echo -e "\e[33m资源组已存在 $location\e[0m"
        else
            errorMessage=$(echo "$groupInfo" | grep -oP "(?<=Message:\s).+")
            az group create --name "$location" --location "$location"
            if [ $? -eq 0 ]; then
                echo -e "\e[32m资源组创建成功 $location\e[0m"
            else
                echo -e "\e[31m资源组创建失败 $location\e[0m"
                echo -e "\e[31m$errorMessage\e[0m"
                allGroupsCreated=false
            fi
        fi
    done
    
    if $allGroupsCreated; then
        break
    fi
done
