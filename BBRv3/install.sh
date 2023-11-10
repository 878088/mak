#!/bin/bash
kernel=$(uname -r)
current_tcp_algorithm=$(cat /proc/sys/net/ipv4/tcp_congestion_control)
available_tcp_algorithms=$(cat /proc/sys/net/ipv4/tcp_available_congestion_control)
default_qdisc=$(sysctl net.core.default_qdisc | awk '{print $3}')

if ! command -v jq &> /dev/null; then
    echo -e "\033[33m检测没有JQ正在安装...\033[0m"
    if sudo apt-get update -y > /dev/null && sudo apt-get install jq -y > /dev/null; then
        echo -e "\033[32m安装JQ成功\033[0m"
    else
        echo -e "\033[31m安装JQ失败\033[0m"
        exit 1
    fi
fi

install_BBRv3() {
    API="https://api.github.com/repos/878088/BBRv3/releases"
    response=$(curl -s "$API")
    download_urls=$(echo "$response" | jq -r '.[0].assets[] | select((.browser_download_url | contains("linux-libc-dev")) | not) | .browser_download_url')
    arch=$(dpkg --print-architecture)
    if [ "$arch" == "amd64" ]; then
        download_urls=$(echo "$download_urls" | grep "amd64")
    elif [ "$arch" == "arm64" ]; then
        download_urls=$(echo "$download_urls" | grep "arm64")
    else
        echo -e "\033[31m不支持的架构: $arch\033[0m"
        exit 1
    fi
    mkdir -p BBRv3
    while read -r url; do
        filename=$(basename "$url")
        echo -e "\033[33m正在下载: $filename\033[0m"
        wget -q --show-progress "$url" -P BBRv3
    done <<< "$download_urls"
    if [ -d "BBRv3" ]; then
        cd BBRv3 && dpkg -i *.deb
        if [ $? -eq 0 ]; then
            echo -e "\033[32m\n🎉🎉安装成功🎉🎉请使用{reboot}重启\033[0m"
            cd
            rm -rf BBRv3
        else
            echo -e "\033[31m\n😭😭安装失败😭😭\033[0m"
            exit 1
        fi
        cd
        rm -rf BBRv3
        else
        echo -e "\033[31m\n😭😭找不到目录😭😭\033[0m"
        exit 1
    fi
}
uninstall_BBRv3() {
if dpkg --list | grep linux-image; then
    dpkg -l | grep bbrv3 | awk '{print $2}' | xargs apt-get purge -y
    echo -e "\033[32m\nBBRv3 已成功卸载\033[0m"
else
    echo -e "\033[31m\n未安装 BBRv3\033[0m"
fi
}
install_sysctl() {
sysctl="/etc/sysctl.conf"
if [ -f /etc/sysctl.conf ]; then
    echo "fs.file-max = 2000000" >> "$sysctl"
    echo "net.core.default_qdisc = fq_codel" >> "$sysctl"
    echo "net.ipv4.tcp_congestion_control = bbr" >> "$sysctl"
    echo "net.core.netdev_max_backlog = 16384" >> "$sysctl"
    echo "net.core.optmem_max = 65535" >> "$sysctl"
    echo "net.ipv4.tcp_rmem = 8192 1048576 16777216" >> "$sysctl"
    echo "net.core.somaxconn = 65535" >> "$sysctl"
    echo "net.ipv4.tcp_ecn = 1" >> "$sysctl"
    echo "net.ipv4.tcp_wmem = 8192 1048576 16777216" >> "$sysctl"
    echo "net.ipv4.tcp_notsent_lowat = 16384" >> "$sysctl"
    echo "net.ipv4.ip_forward = 1" >> "$sysctl"
    echo "net.ipv4.tcp_fastopen = 3" >> "$sysctl"
    echo "net.ipv4.tcp_fin_timeout = 25" >> "$sysctl"
    echo "net.ipv4.tcp_max_orphans = 819200" >> "$sysctl"
    echo "net.ipv4.tcp_max_syn_backlog = 20480" >> "$sysctl"
    echo "net.ipv4.tcp_max_tw_buckets = 1440000" >> "$sysctl"
    echo "net.ipv4.tcp_mem = 65536 131072 262144" >> "$sysctl"
    echo "net.ipv4.tcp_mtu_probing = 1" >> "$sysctl"
    echo "net.ipv4.tcp_retries2 = 8" >> "$sysctl"
    echo "net.ipv4.tcp_slow_start_after_idle = 0" >> "$sysctl"
    echo "net.ipv4.tcp_window_scaling = 1" >> "$sysctl"
    echo "net.ipv4.udp_mem = 65536 131072 262144" >> "$sysctl"
    echo "net.ipv6.conf.all.disable_ipv6 = 0" >> "$sysctl"
    echo "net.ipv6.conf.all.forwarding = 1" >> "$sysctl"
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> "$sysctl"
    echo "net.unix.max_dgram_qlen = 50" >> "$sysctl"
    echo "vm.min_free_kbytes = 65536" >> "$sysctl"
    echo "vm.swappiness = 10" >> "$sysctl"
    echo "vm.vfs_cache_pressure = 50" >> "$sysctl"
    sysctl -p
    echo -e "\033[32m\n已添加Linux参数\033[0m"
fi
}
uninstall_sysctl() {
sysctl="/etc/sysctl.conf"
sed -i '/^fs.file-max/d' "$sysctl"
sed -i '/^net.core.default_qdisc/d' "$sysctl"
sed -i '/^net.ipv4.tcp_congestion_control/d' "$sysctl"
sed -i '/^net.core.netdev_max_backlog/d' "$sysctl"
sed -i '/^net.core.optmem_max/d' "$sysctl"
sed -i '/^net.ipv4.tcp_rmem/d' "$sysctl"
sed -i '/^net.core.somaxconn/d' "$sysctl"
sed -i '/^net.ipv4.tcp_ecn/d' "$sysctl"
sed -i '/^net.ipv4.tcp_wmem/d' "$sysctl"
sed -i '/^net.ipv4.tcp_notsent_lowat/d' "$sysctl"
sed -i '/^net.ipv4.ip_forward/d' "$sysctl"
sed -i '/^net.ipv4.tcp_fastopen/d' "$sysctl"
sed -i '/^net.ipv4.tcp_fin_timeout/d' "$sysctl"
sed -i '/^net.ipv4.tcp_max_orphans/d' "$sysctl"
sed -i '/^net.ipv4.tcp_max_syn_backlog/d' "$sysctl"
sed -i '/^net.ipv4.tcp_max_tw_buckets/d' "$sysctl"
sed -i '/^net.ipv4.tcp_mem/d' "$sysctl"
sed -i '/^net.ipv4.tcp_mtu_probing/d' "$sysctl"
sed -i '/^net.ipv4.tcp_retries2/d' "$sysctl"
sed -i '/^net.ipv4.tcp_slow_start_after_idle/d' "$sysctl"
sed -i '/^net.ipv4.tcp_window_scaling/d' "$sysctl"
sed -i '/^net.ipv4.udp_mem/d' "$sysctl"
sed -i '/^net.ipv6.conf.all.disable_ipv6/d' "$sysctl"
sed -i '/^net.ipv6.conf.all.forwarding/d' "$sysctl"
sed -i '/^net.ipv6.conf.default.disable_ipv6/d' "$sysctl"
sed -i '/^net.unix.max_dgram_qlen/d' "$sysctl"
sed -i '/^vm.min_free_kbytes/d' "$sysctl"
sed -i '/^vm.swappiness/d' "$sysctl"
sed -i '/^vm.vfs_cache_pressure/d' "$sysctl"
sysctl -p
    echo -e "\033[32m\n已卸载Linux参数\033[0m"
}

echo -e "\033[37m\n一键安装~BBRv3~脚本\033[0m"
echo ""
033[0m"
echo -e "\033[33m当前内核版本: \033[32m$kernel\033[0m"
echo -e "\033[33m内核TCP拥塞控制算法: \033[32m$current_tcp_algorithm\033[0m"
033[0m"
echo -e "\033[33m队列算法: \033[32m$default_qdisc\033[0m"
echo -e "\033[33m内核支持的TCP拥塞控制算法: \033[32m$available_tcp_algorithms\
echo -e "\033[32m\n——————————————————————\033[0m"
echo -e "\033[33m1. \033[37m 安装~BBRv3 \033[0m"
echo -e "\033[33m2. \033[37m 卸载~BBRv3 \033[0m"
echo -e "\033[32m——————————————————————\033[0m"
echo -e "\033[33m3. \033[37m 安装Linux内核参数 \033[0m"
echo -e "\033[33m4. \033[37m 卸载Linux内核参数 \033[0m"
echo -e "\033[32m——————————————————————\033[0m"
echo -e "\033[33m0. \033[37m 退出 \033[0m"

read -p "选择安装: " choice

case $choice in
    1)
        install_BBRv3
        ;;
    2)
        uninstall_BBRv3
        ;;
    3)
        install_sysctl
        ;;
    4)
        uninstall_sysctl
        ;;
    0)
        echo -e "\033[33m退出...\033[0m"
        ;;
    *)
        echo -e "\033[31m选择无效\033[0m"
        ;;
esac
