#!/bin/bash

# 检查 /usr/bin 下的 Python 版本
PYTHON_VERSIONS=$(ls /usr/bin/python* | grep -E 'python[0-9\.]+$')

if [ -z "$PYTHON_VERSIONS" ]; then
    echo "未找到 Python 版本 /usr/bin"
    exit 0
fi

echo "找到以下Python版本:"
echo "$PYTHON_VERSIONS"

# 提示用户确认卸载
read -p "您需要卸载所有 Python 版本吗？ (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "卸载取消"
    exit 0
fi

# 检查用户是否有 sudo 权限
if sudo -v 2>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

# 卸载找到的每个 Python 版本
for PYTHON_PATH in $PYTHON_VERSIONS; do
    PYTHON_VERSION=$(basename $PYTHON_PATH)
    echo "卸载 $PYTHON_VERSION..."

    # 查找对应的包名称
    PACKAGE=$(dpkg -S $PYTHON_PATH 2>/dev/null | cut -d: -f1 | uniq)
    if [ -n "$PACKAGE" ]; then
        sudo apt-get remove --purge -y $PACKAGE
    else
        echo "Package for $PYTHON_VERSION not found. It may have been installed manually."
    fi
done

# 清理系统
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo "所有 Python 版本已卸载."
