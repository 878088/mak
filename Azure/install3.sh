LOCATIONS=("westus3")

VM_IMAGE="Debian11"
VM_SIZE="Standard_D4as_v4"

while true; do
    echo -e "\e[32m用户名不能包含大写字符 A-Z、特殊字符 \\/\"[]:|<>+=;,?*@#()! 或以 $ 或 - 开头\e[0m"
    echo -e "\e[32m密码长度必须在 12 到 72 之间。密码必须包含以下 3 个字符：1 个小写字符、1 个大写字符、1 个数字和 1 个特殊字符\e[0m"
    read -p "请输入实例用户名: " USERNAME
    read -p "请输入实例密码: " PASSWORD

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

if ! echo "$PASSWORD" | grep -q '[!@#\$%^\&*()]'; then
    echo -e "\e[32m错误: 密码必须包含至少一个特殊字符。\e[0m"
    continue
fi

    echo -e "\e[32m用户名和密码验证成功\e[0m"
    break
done

for LOCATION in "${LOCATIONS[@]}"; do
    RESOURCE_GROUP="$LOCATION-rg"

    if az group exists --name "$RESOURCE_GROUP"; then
        echo -e "\e[32m资源组 $RESOURCE_GROUP 已存在，将不再创建\e[0m"
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

echo -e "\e[32m所有资源已创建完成\e[0m"
