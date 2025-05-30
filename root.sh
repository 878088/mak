#!/bin/bash

ROOTFS_DIR=$(pwd)
ARCH=$(uname -m)
CURRENT_USER=$(whoami)
export PATH=$PATH:$ROOTFS_DIR/usr/local/bin

# 配色
CYAN='\e[0;36m'
WHITE='\e[0;37m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
RESET='\e[0m'

# 显示信息
display_help() {
  echo -e "${CYAN}Ubuntu Proot 环境安装脚本${RESET}"
  echo -e "${WHITE}使用方法:${RESET}"
  echo -e "  ${GREEN}./root.sh${RESET}         - 安装Ubuntu Proot环境"
  echo -e "  ${GREEN}./root.sh del${RESET}     - 删除所有配置和文件"
  echo -e "  ${GREEN}./root.sh help${RESET}    - 显示此帮助信息"
}

delete_all() {
  echo -e "${YELLOW}正在删除所有配置和文件...${RESET}"
  find "$ROOTFS_DIR" -mindepth 1 -not -name "root.sh" -not -name "README.md" \
    -not -name ".git" -not -path "*/.git/*" -exec rm -rf {} \; 2>/dev/null
  echo -e "${GREEN}已删除！如需重新安装，请运行：./root.sh${RESET}"
  exit 0
}

if [ "$1" = "del" ]; then
  delete_all
elif [ "$1" = "help" ]; then
  display_help
  exit 0
fi

echo "当前用户: $CURRENT_USER"
echo "系统架构: $ARCH"
echo "工作目录: $ROOTFS_DIR"

# 映射架构名
case "$ARCH" in
  x86_64) ARCH_ALT=amd64 ;;
  aarch64) ARCH_ALT=arm64 ;;
  *) echo "不支持的架构: $ARCH"; exit 1 ;;
esac

# 如果未安装，开始安装
if [ ! -e "$ROOTFS_DIR/.installed" ]; then
  echo -e "${CYAN}是否安装Ubuntu环境？ (YES/no)${RESET}"
  read install_ubuntu
  if [[ "$install_ubuntu" =~ ^[Yy][Ee]?[Ss]?$ ]]; then
    echo "正在下载 Ubuntu 根文件系统..."
    wget -O /tmp/rootfs.tar.gz \
      "https://partner-images.canonical.com/core/focal/current/ubuntu-focal-core-cloudimg-${ARCH_ALT}-root.tar.gz"

    echo "正在解压..."
    tar -xf /tmp/rootfs.tar.gz -C "$ROOTFS_DIR"
    rm /tmp/rootfs.tar.gz
  else
    echo "跳过 Ubuntu 安装。"
  fi

  echo "下载 proot..."
  mkdir -p $ROOTFS_DIR/usr/local/bin
  retry_count=0
  max_retries=20
  until wget -O $ROOTFS_DIR/usr/local/bin/proot \
      "https://raw.githubusercontent.com/zhumengkang/agsb/main/proot-${ARCH}" && \
      [ -s "$ROOTFS_DIR/usr/local/bin/proot" ]; do
    ((retry_count++))
    echo "下载失败，重试 ($retry_count/$max_retries)..."
    if [ $retry_count -ge $max_retries ]; then
      echo -e "${RED}proot 下载失败，已达最大重试次数。${RESET}"
      exit 1
    fi
    sleep 1
  done

  chmod +x $ROOTFS_DIR/usr/local/bin/proot

  echo "配置 DNS..."
  echo -e "nameserver 1.1.1.1\nnameserver 8.8.8.8" | tee $ROOTFS_DIR/etc/resolv.conf > /dev/null

  touch "$ROOTFS_DIR/.installed"
fi

# 创建必要目录
mkdir -p "$ROOTFS_DIR/home/$CURRENT_USER"
mkdir -p "$ROOTFS_DIR/root"

# .bashrc
cat > "$ROOTFS_DIR/root/.bashrc" << EOF
if [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi
PS1='[proot:\w]# '
EOF

# init.sh
cat > "$ROOTFS_DIR/root/init.sh" << EOF
#!/bin/sh
set -e

HOST_USER="$CURRENT_USER"
mkdir -p /home/\$HOST_USER 2>/dev/null

echo "备份原始源..."
cp /etc/apt/sources.list /etc/apt/sources.list.bak 2>/dev/null || true

echo "写入新版源..."
cat > /etc/apt/sources.list <<SOURCES
deb http://archive.ubuntu.com/ubuntu focal main universe restricted multiverse
deb http://archive.ubuntu.com/ubuntu focal-updates main universe restricted multiverse
deb http://security.ubuntu.com/ubuntu focal-security main universe restricted multiverse
SOURCES

echo "更新系统并安装常用软件..."
apt update
apt install -y bash curl wget git vim nano python3 python3-pip build-essential locales iproute2

echo "初始化完成。可以使用 'bash' 进入完整 shell。"
EOF

chmod +x "$ROOTFS_DIR/root/init.sh"

# 启动脚本
cat > "$ROOTFS_DIR/start-proot.sh" << EOF
#!/bin/bash
echo "正在启动 proot 环境..."
cd "$ROOTFS_DIR"
env -i HOME=/root TERM=\$TERM PATH=/bin:/usr/bin:/sbin:/usr/sbin \
$ROOTFS_DIR/usr/local/bin/proot \\
  --rootfs="$ROOTFS_DIR" \\
  -0 -w /root -b /dev -b /sys -b /proc -b /etc/resolv.conf --kill-on-exit \\
  /bin/sh -c "/root/init.sh && exec /bin/bash || exec /bin/sh"
EOF

chmod +x "$ROOTFS_DIR/start-proot.sh"

# 清屏并完成
clear
echo -e "${GREEN}✔ Ubuntu Proot 环境安装完成！${RESET}"
echo -e "${WHITE}使用命令：${CYAN}./start-proot.sh${RESET} 启动。输入 'exit' 可退出。"
echo -e "${WHITE}如需删除环境，请使用：${YELLOW}./root.sh del${RESET}"

echo -e "\n${CYAN}是否现在启动 Proot 环境？(y/n):${RESET}"
read start_now
if [[ "$start_now" =~ ^[Yy]$ ]]; then
  bash "$ROOTFS_DIR/start-proot.sh"
else
  echo "稍后可手动运行 ./start-proot.sh 启动环境"
fi
