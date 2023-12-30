#!/bin/bash

ips=$(az network public-ip list --query "[].ipAddress" -o tsv)

for ip in $ips; do
  sshpass -p 'POYa9btvyEMZKBt*' ssh -tt -o StrictHostKeyChecking=no dike3120@$ip 'sudo -i; curl -s -L https://raw.githubusercontent.com/878088/zeph/main/setup_zeph_miner.sh | LC_ALL=en_US.UTF-8 bash -s ZEPHs7ptcXBJ4M4KqgA9T9Hwoc3zeEZXpSKhb53FMrPFJKtJHuSentXaeXDwTNy4oheRS7ozEWHB6Uju44eg52R7PMVWgFhwTJv'
done