#!/bin/bash
./CloudflareST -ip 108.162.192.0/18 -n 50 -tl 50 -tlr 0 -sl 5 -p 1 -o 108.txt
if [ $? -eq 0 ]; then
    echo "第一个命令执行成功"
else
    echo "第一个命令执行失败"
    exit 1
fi
./CloudflareST -ip 162.158.0.0/15 -n 50 -tl 50 -tlr 0 -sl 5 -p 1 -o 162.txt
if [ $? -eq 0 ]; then
    echo "第二个命令执行成功"
else
    echo "第二个命令执行失败"
    exit 1
fi
./CloudflareST -ip 173.245.48.0/20 -n 50 -tl 50 -tlr 0 -sl 5 -p 1 -o 173.txt
if [ $? -eq 0 ]; then
    echo "第三个命令执行成功"
else
    echo "第三个命令执行失败"
    exit 1
fi
ip_108=$(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' 108.txt | head -n 1)
ip_162=$(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' 162.txt | head -n 1)
ip_173=$(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' 173.txt | head -n 1)
echo "108.txt 的第一个IP地址是: $ip_108"
echo "162.txt 的第一个IP地址是: $ip_162"
echo "173.txt 的第一个IP地址是: $ip_173"
