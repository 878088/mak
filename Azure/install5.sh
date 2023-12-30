#!/bin/bash
ips=$(az network public-ip list --query "[].ipAddress" -o tsv)

for ip in $ips; do
  sshpass -p 'POYa9btvyEMZKBt*' ssh -o StrictHostKeyChecking=no dike3120@$ip 'echo "POYa9btvyEMZKBt*" | sudo -S bash'
done