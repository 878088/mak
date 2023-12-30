LOCATIONS=("westus3")

VM_IMAGE="Debian11"
VM_SIZE="Standard_D4as_v4"

while true; do
    echo -e "\e[32m用户名不能包含大写字符 A-Z、特殊字符 \\/\"[]:|<>+=;,?*@#()! 或以 $ 或 - 开头\e[0m"
    echo -e "\e[32m密码长度必须在 12 到 72 之间。密码必须包含以下 3 个字符：1 个小写字符、1 个大写字符、1 个数字和 1 个特殊字符\e[0m"
    echo -e
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
    echo -e
    echo -e "\e[32m用户名和密码验证成功\e[0m"
    break
done

for LOCATION in "${LOCATIONS[@]}"; do

    az group create --name "$LOCATION-rg" --location $LOCATION

    output=$(az vm create \
        --resource-group "$LOCATION-rg" \
        --name "$LOCATION-vm" \
        --location $LOCATION \
        --image $VM_IMAGE \
        --size $VM_SIZE \
        --admin-username "$USERNAME" \
        --admin-password "$PASSWORD" \
        --security-type Standard \
        --public-ip-sku Basic \
        --public-ip-address-allocation Dynamic 2>&1)

    if [ $? -eq 0 ]; then
        echo -e "\e[32m$LOCATION-vm 虚拟机创建成功\e[0m"
    else
        echo -e "\e[31m$LOCATION-vm 虚拟机创建失败，错误信息如下：\e[0m"
        echo -e "\e[31m$output\e[0m"
        exit 1
    fi
done

echo -e "\e[32m所有资源已创建完成\e[0m"