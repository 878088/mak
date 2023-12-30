LOCATIONS=("westus3")

VM_IMAGE="Debian11"
VM_SIZE="Standard_D4as_v4"

while true; do
    read -p "请输入用户名: " USERNAME
    read -p "请输入密码: " PASSWORD
    echo

    if [[ "$USERNAME" =~ [A-Z] || "$USERNAME" =~ [\\/\\[\\]:|+=;,?*@#()!] || "$USERNAME" =~ ^[\\$-] || "$USERNAME" =~ '<' || "$USERNAME" =~ '>' ]]; then
        echo "错误: 用户名不能包含大写字符 A-Z、特殊字符 \\/\"[]:|<>+=;,?*@#()! 或以 $ 或 - 开头"
        continue
    fi

    PASSWORD_LENGTH=${#PASSWORD}
    if [[ $PASSWORD_LENGTH -lt 12 || $PASSWORD_LENGTH -gt 72 || !("$PASSWORD" =~ [a-z] && "$PASSWORD" =~ [A-Z] && "$PASSWORD" =~ [0-9] && "$PASSWORD" =~ [!@#\\$%\\^&*\\(\\)_+\\-\\=\\[\\]{};':\"\\\\|,./?] ) || "$PASSWORD" =~ '<' || "$PASSWORD" =~ '>' ]]; then
        echo "错误: 密码长度必须在 12 到 72 之间。密码必须包含以下 3 个字符：1 个小写字符、1 个大写字符、1 个数字和 1 个特殊字符"
        continue
    fi

    echo "用户名和密码验证成功"
    break
done

for LOCATION in "${LOCATIONS[@]}"; do
    RESOURCE_GROUP="$LOCATION-rg"

    if az group exists --name "$RESOURCE_GROUP"; then
        echo "资源组 $RESOURCE_GROUP 已存在，将不再创建"
    else
        az group create --name "$RESOURCE_GROUP" --location $LOCATION
    fi

    az vm create \
        --resource-group "$RESOURCE_GROUP" \
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

echo "所有资源已创建完成"
