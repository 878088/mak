#!/bin/bash
LOCATIONS=("westus3" "australiaeast" "uksouth" "southeastasia" "swedencentral" "centralus" "centralindia" "eastasia" "japaneast" "koreacentral" "canadacentral" "francecentral" "germanywestcentral" "italynorth" "norwayeast" "polandcentral" "switzerlandnorth" "brazilsouth" "northcentralus" "westus" "japanwest" "australiacentral" "canadaeast" "ukwest" "southcentralus" "northeurope" "southafricanorth" "australiasoutheast" "southindia" "uaenorth")
while true; do
    for location in "${LOCATIONS[@]}"; do
        az group create --name "$location" --location "$location" --no-wait
        if [ $? -eq 0 ]; then
            echo "资源组创建成功 $location"
        else
            echo "资源组创建失败 $location"
            allGroupsCreated=false
        fi
    done    
    if $allGroupsCreated; then
        break
    fi
done
