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
