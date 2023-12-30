for rg in $(az group list --query "[].name" -o tsv)
do
   az group delete --name $rg --yes --no-wait
done