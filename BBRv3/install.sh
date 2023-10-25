#!/bin/bash
if ! command -v jq &> /dev/null; then
    apt install -y jq wget > /dev/null
fi
kernel=$(uname -r)
version=$(curl -s https://www.kernel.org/releases.json | jq -r '.latest_stable.version')
install_BBRv3() {
    API="https://api.github.com/repos/878088/BBRv3/releases"
    response=$(curl -s "$API")
    download_urls=$(echo "$response" | jq -r '.[].assets[] | select((.browser_download_url | contains("linux-libc-dev")) | not) | .browser_download_url')
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
            cd
            rm -rf BBRv3
        else
            echo ""
            echo "安装失败"
            exit 1
        fi
        cd
        rm -rf BBRv3
        else
        echo ""
        echo "找不到目录"
        exit 1
    fi
}
uninstall_BBRv3() {
if dpkg --list | grep linux-image; then
    dpkg -l | grep bbrv3 | awk '{print $2}' | xargs apt-get purge -y
    echo ""
    echo "BBRv3已成功卸载"
else
    echo ""
    echo "   BBRv3未安装"
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
    echo ""
    echo "添加加速完成"
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
    echo ""
    echo "卸载加速完成"
}
# Menu display
echo ""
echo "  一键安装~BBRv3~脚本   "
echo ""
echo "最新Kernel: $version"
echo "系统内核版本: $kernel"
echo ""
echo "——————————————————————"
echo "1. ~安装~BBRv3~"
echo "2. ~卸载~BBRv3~"
echo "——————————————————————"
echo "3. ~安装Linux内核参数~"
echo "4. ~卸载Linux内核参数~"
echo "——————————————————————"
echo "0. ~退出~"

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
        echo "Exiting..."
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
