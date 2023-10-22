RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'
red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}
green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}
install_BBRv3(){
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
        echo "成功安装BBRv3"
        echo "☞请重启系统☜"
        cd .. && rm -rf BBRv3
    else
        echo "安装BBRv3失败"
        exit 1
    fi
    cd .. && rm -rf BBRv3
else
    echo "没有BBRv3目录"
    exit 1
fi
}

menu(){
    clear
    echo "#############################################################"
    echo -e "#               ${RED}BBRv3 一键安装脚本${PLAIN}           #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} 安装 BBRv3"
    echo -e " ${GREEN}0.${PLAIN} 退出"
    echo ""
    read -rp " 请输入选项 [0-6] ：" answer
    case $answer in
        1) install_BBRv3 ;;
        *) red "请输入正确的选项 [0-6]！" && exit 1 ;;
    esac
}

menu
    
