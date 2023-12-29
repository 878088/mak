LOCATIONS=("eastus" "eastus2")

VM_IMAGE="Debian11"
VM_SIZE="Standard_D4as_v4"

read -p "请输入用户名: " ADMIN_USERNAME
read -p "请输入密码: " ADMIN_PASSWORD
echo

if [[ -z "$ADMIN_USERNAME" || -z "$ADMIN_PASSWORD" ]]; then
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
        --admin-username "$ADMIN_USERNAME" \
        --admin-password "$ADMIN_PASSWORD" \
        --security-type Standard \
        --public-ip-sku Basic \
        --public-ip-address-allocation Dynamic

done

echo "所有资源已创建完成。"