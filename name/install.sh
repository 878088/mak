#!/bin/bash

if [ ! -d "Name.com" ]; then
   mkdir "Name.com"
fi
read -p "请输入用户名: " name
read -p "请输入令牌: " token
read -p "请输入域名: " domain
read -p "请输入CFNS: " NS
read -p "请输入CFNS2: " NS2

cat > Name.com/NameDNS.sh <<EOF
curl -u '$name:$token' 'https://api.name.com/v4/domains/$domain:setNameservers' -X POST -H 'Content-Type: application/json' --data '{"nameservers":["ns1.name.com","ns2.name.com","ns3.name.com","ns4.name.com"]}'
EOF
cat > Name.com/CFDNS.sh <<EOF
curl -u '$name:$token' 'https://api.name.com/v4/domains/$domain:setNameservers' -X POST -H 'Content-Type: application/json' --data '{"nameservers":["$NS","$NS2"]}'
EOF
chmod +x Name.com/*.sh
