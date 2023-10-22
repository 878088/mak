#!/bin/bash

install_BBRv3() {
    API="https://api.github.com/repos/878088/BBRv3/releases"
    response=$(curl -s "$API")
    download_urls=$(echo "$response" | jq -r '.[].assets[] | select(.browser_download_url | contains("linux-headers") or contains("linux-image") or contains("linux-libc-dev")) | .browser_download_url')
    arch=$(dpkg --print-architecture)
    if [ "$arch" == "amd64" ]; then
        download_urls=$(echo "$download_urls" | grep "amd64")
    elif [ "$arch" == "arm64" ]; then
        download_urls=$(echo "$download_urls" | grep "arm64")
    else
        echo "Unsupported architecture: $arch"
        exit 1
    fi
    mkdir -p BBRv3
    while read -r url; do
        filename=$(basename "$url")
        echo "Downloading: $filename"
        wget -q --show-progress "$url" -P BBRv3
    done <<< "$download_urls"
    if [ -d "BBRv3" ]; then
        cd BBRv3 && dpkg -i *.deb
        if [ $? -eq 0 ]; then
            echo "成功安装B·B·R·v·3"
            echo "·请重启系统·"
            cd .. && rm -rf BBRv3
        else
            echo "安装B·B·R·v·3失败"
            exit 1
        fi
        cd .. && rm -rf BBRv3
    else
        echo "没有B·B·R·v·3目录"
        exit 1
    fi
}

# Menu display
echo "BBRv3 Installation Menu"
echo "1. Install BBRv3"
echo "2. Exit"

read -p "Enter your choice: " choice

case $choice in
    1)
        install_BBRv3
        ;;
    2)
        echo "Exiting..."
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
