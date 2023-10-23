#!/bin/bash
if ! command -v jq &> /dev/null; then
    apt-get install -y jq > /dev/null
fi
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
            echo ""
            echo "成功安装~请重启"
            cd .. && rm -rf BBRv3
        else
            echo ""
            echo "安装失败"
            exit 1
        fi
        cd .. && rm -rf BBRv3
        else
        echo ""
        echo "找不到目录"
        exit 1
    fi
}
uninstall_BBRv3() {
if dpkg --list | grep linux-image; then
    dpkg -l | grep bbrv3 | awk '{print $2}' | xargs apt-get purge -y
    echo "BBRv3已成功卸载"
else
    echo "   BBRv3未安装"
fi
}
# Menu display
echo ""
echo "  一键安装~BBRv3~脚本   "
echo ""
echo "1. ~安装~BBRv3~"
echo "2. ~卸载~BBRv3~"
echo "0. ~退出~"

read -p "选择安装: " choice

case $choice in
    1)
        install_BBRv3
        ;;
    2)
        uninstall_BBRv3
        ;;
    0)
        echo "Exiting..."
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
