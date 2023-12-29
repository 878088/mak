LOCATIONS=("westus3" "australiaeast" "uksouth" "southcentralus" "southeastasia" "swedencentral" "centralus" "centralindia" "eastasia" "japaneast" "koreacentral" "canadacentral" "francecentral" "germanywestcentral" "italynorth" "norwayeast" "polandcentral" "switzerlandnorth" "uaenorth" "brazilsouth" "northcentralus" "westus" "japanwest" "australiacentral" "canadaeast" "ukwest")

VM_IMAGE="Debian11"
VM_SIZE="Standard_D4as_v4"

read -p "请输入用户名: " USERNAME
read -p "请输入密码: " PASSWORD
echo

if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    echo "用户名和密码不能为空"
    exit 1
fi

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

echo "所有资源已创建完成。"