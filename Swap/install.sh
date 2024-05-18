#bash
Green="\033[32m"
Font="\033[0m"
Red="\033[31m"

# 检查root权限
root_need(){
    if [[ $EUID -ne 0 ]]; then
        echo -e "${Red}错误: 此脚本必须以root身份运行！${Font}"
        exit 1
    fi
}

# 检查VPS是否基于OpenVZ
ovz_no(){
    if [[ -d "/proc/vz" ]]; then
        echo -e "${Red}您的VPS基于OpenVZ，不支持此操作！${Font}"
        exit 1
    fi
}

# 添加swap函数
add_swap(){
    echo -e "${Green}请输入要添加的swap大小（建议为内存的2倍）${Font}"
    read -p "请输入swap大小（MB）: " swapsize

    # 验证输入
    if ! [[ "$swapsize" =~ ^[0-9]+$ ]] ; then
       echo -e "${Red}错误: 请输入一个有效的数字！${Font}"
       exit 1
    fi

    # 检查是否已存在swapfile
    if ! grep -q "swapfile" /etc/fstab; then
        echo -e "${Green}正在创建swapfile...${Font}"
        if ! fallocate -l ${swapsize}M /swapfile; then
            echo -e "${Red}错误: 分配swapfile失败！${Font}"
            exit 1
        fi
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile -p 10  # 设置swap优先级为10
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        echo -e "${Green}swap创建成功。swap详情:${Font}"
        cat /proc/swaps
        grep Swap /proc/meminfo
    else
        echo -e "${Red}swapfile已存在。请先删除现有的swapfile，再创建新的。${Font}"
    fi
}

# 删除swap函数
del_swap(){
    if grep -q "swapfile" /etc/fstab; then
        echo -e "${Green}正在移除swapfile...${Font}"
        sed -i '/swapfile/d' /etc/fstab
        swapoff /swapfile
        rm -f /swapfile
        echo "3" > /proc/sys/vm/drop_caches
        echo -e "${Green}swap已成功删除！${Font}"
    else
        echo -e "${Red}未发现swapfile。没有可以删除的swap。${Font}"
    fi
}

# 显示当前内存和swap使用情况
show_memory_info(){
    echo -e "${Green}当前内存和swap使用情况:${Font}"
    free -h
}

# 主菜单
main(){
    root_need
    ovz_no
    clear
    show_memory_info
    echo -e "———————————————————————————————————————"
    echo -e "${Green}Linux VPS Swap管理脚本${Font}"
    echo -e "${Green}1. 添加swap${Font}"
    echo -e "${Green}2. 删除swap${Font}"
    echo -e "${Green}3. 退出${Font}"
    echo -e "———————————————————————————————————————"
    read -p "请输入选项 [1-3]: " num
    case "$num" in
        1)
            add_swap
            ;;
        2)
            del_swap
            ;;
        3)
            exit 0
            ;;
        *)
            echo -e "${Red}无效选择！请输入1到3之间的数字。${Font}"
            sleep 2s
            main
            ;;
    esac
}

main
