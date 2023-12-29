declare -A REGIONS
REGIONS=(
  ["华东"]="eastasia"
  ["华南"]="southeastasia"
  ["美国中部"]="centralus"
  ["美国东部"]="eastus"
  ["美国东部 2"]="eastus2"
  ["美国西部"]="westus"
  ["美国西部 2"]="westus2"
  ["美国北部"]="northcentralus"
  ["美国南部"]="southcentralus"
  # 添加更多地区...
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

az group create --name $REGION_CODE --location $REGION_CODE && az vm create --resource-group $REGION_CODE --name $REGION_CODE --location $REGION_CODE --image Debian11 --size Standard_B1s --admin-username ooo --admin-password JINguang520. --security-type Standard --public-ip-sku Basic --public-ip-address-allocation Dynamic
