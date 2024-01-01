#!/bin/bash

echo -e "\e[32m用户名不能包含大写字符 A-Z、特殊字符 \\/\"[]:|<>+=;,?*@#()! 或以 $ 或 - 开头\e[0m"
echo -e "\e[32m密码长度必须在 12 到 72 之间。密码必须包含以下 3 个字符：1 个小写字符、1 个大写字符、1 个数字和 1 个特殊字符\e[0m"
echo -e
read -p "请输入实例用户名: " USERNAME
read -p "请输入实例密码: " PASSWORD

mkdir -p azure

count=1

while true; do
    SCRIPT="azure/script${count}.sh"
    echo "#!/bin/bash" > $SCRIPT
    echo "USERNAME=\"$USERNAME\"" >> $SCRIPT
    echo "PASSWORD=\"$PASSWORD\"" >> $SCRIPT
    echo "WALLET=\"$WALLET\"" >> $SCRIPT
    echo 'LOCATIONS=("westus3" "australiaeast" "uksouth" "southeastasia" "swedencentral" "centralus" "centralindia" "eastasia" "japaneast" "koreacentral" "canadacentral" "francecentral" "germanywestcentral" "italynorth" "norwayeast" "polandcentral" "switzerlandnorth" "uaenorth" "brazilsouth" "northcentralus" "westus" "japanwest" "australiacentral" "canadaeast" "ukwest" "southcentralus" "northeurope" "southafricanorth" "australiasoutheast" "southindia")' >> $SCRIPT
    echo 'VM_IMAGE="Debian11"' >> $SCRIPT
    echo 'VM_SIZE="Standard_D4as_v4"' >> $SCRIPT
    echo 'VM_SIZE_VM="Standard_D4ds_v4"' >> $SCRIPT
    cat <<'EOF' >> $SCRIPT
for LOCATION in "${LOCATIONS[@]}"; do
    az group create --name "$LOCATION-rg" --location $LOCATION
    az vm create \
        --resource-group "$LOCATION-rg" \
        --name "$LOCATION-vm" \
        --location $LOCATION \
        --image $VM_IMAGE \
        --size $VM_SIZE \
        --admin-username "$USERNAME" \
        --admin-password "$PASSWORD" \
        --security-type Standard \
        --public-ip-sku Basic \
        --public-ip-address-allocation Dynamic
done
EOF
    chmod +x $SCRIPT

    count=$((count+1))

    if [[ $count -gt 5 ]]; then
        break
    fi
done
