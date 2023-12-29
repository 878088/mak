declare -A REGIONS
REGIONS=(
  ["美国东部"]="eastus"
  ["美国东部 2"]="eastus2"
  ["美国南部中心"]="southcentralus"
  ["美国西部 2"]="westus2"
  ["美国西部 3"]="westus3"
  ["澳大利亚东部"]="australiaeast"
  ["东南亚"]="southeastasia"
  ["北欧"]="northeurope"
  ["瑞典中部"]="swedencentral"
  ["英国南部"]="uksouth"
  ["西欧"]="westeurope"
  ["美国中部"]="centralus"
  ["南非北部"]="southafricanorth"
  ["印度中部"]="centralindia"
  ["东亚"]="eastasia"
  ["日本东部"]="japaneast"
  ["韩国中部"]="koreacentral"
  ["加拿大中部"]="canadacentral"
  ["法国中部"]="francecentral"
  ["德国西部中心"]="germanywestcentral"
  ["意大利北部"]="italynorth"
  ["挪威东部"]="norwayeast"
  ["波兰中部"]="polandcentral"
  ["瑞士北部"]="switzerlandnorth"
  ["阿联酋北部"]="uaenorth"
  ["巴西南部"]="brazilsouth"
  ["美国中部(欧洲亚太)"]="centraluseuap"
  ["以色列中部"]="israelcentral"
  ["卡塔尔中部"]="qatarcentral"
  ["美国中部(测试)"]="centralusstage"
  ["美国东部(测试)"]="eastusstage"
  ["美国东部 2(测试)"]="eastus2stage"
  ["美国北部中心(测试)"]="northcentralusstage"
  ["美国南部中心(测试)"]="southcentralusstage"
  ["美国西部(测试)"]="westusstage"
  ["美国西部 2(测试)"]="westus2stage"
)

declare -A IMAGES
IMAGES=(
  ["CentOS"]="CentOS"
  ["Debian 11"]="Debian11"
  ["Ubuntu 22.04"]="Ubuntu2204"
)

declare -A SIZES
SIZES=(
  ["Standard_B1s"]="Standard_B1s"
  ["Standard_D4as_v4"]="Standard_D4as_v4"
)

echo "请选择一个地区："
select REGION in "${!REGIONS[@]}"; do
  if [ "$REGION" ]; then
    echo "您选择的是 $REGION"
    REGION_CODE=${REGIONS[$REGION]}
    break
  else
    echo "无效的选项"
  fi
done

echo "请选择一个镜像："
select IMAGE in "${!IMAGES[@]}"; do
  if [ "$IMAGE" ]; then
    echo "您选择的是 $IMAGE"
    IMAGE_CODE=${IMAGES[$IMAGE]}
    break
  else
    echo "无效的选项"
  fi
done

echo "请选择一个虚拟机大小："
select SIZE in "${!SIZES[@]}"; do
  if [ "$SIZE" ]; then
    echo "您选择的是 $SIZE"
    SIZE_CODE=${SIZES[$SIZE]}
    break
  else
    echo "无效的选项"
  fi
done

read -p "请输入用户名： " USERNAME
read -sp "请输入密码： " PASSWORD

az group create --name $REGION_CODE --location $REGION_CODE && az vm create --resource-group $REGION_CODE --name $REGION_CODE --location $REGION_CODE --image $IMAGE_CODE --size $SIZE_CODE --admin-username $USERNAME --admin-password $PASSWORD --security-type Standard --public-ip-sku Basic --public-ip-address-allocation Dynamic &&az vm open-port --ids $(az vm list -g $REGION_CODE --query "[].id" -o tsv) --port '*'
