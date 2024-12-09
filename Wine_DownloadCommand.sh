#!/bin/bash

# 确保脚本以root权限运行
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# 记录日志
exec > >(tee -a install_wine.log) 2>&1

echo "Starting Wine installation script..."

# 更新软件包列表
echo "Step 1: Updating package lists..."
sudo apt-get update || { echo "Failed to update package lists."; exit 1; }

# 安装必要的软件包
echo "Step 2: Installing necessary packages..."
sudo apt-get install -y dirmngr ca-certificates curl software-properties-common apt-transport-https || { echo "Failed to install necessary packages."; exit 1; }

# 添加i386架构支持
echo "Step 3: Adding i386 architecture..."
sudo dpkg --add-architecture i386 || { echo "Failed to add i386 architecture."; exit 1; }
sudo apt-get update || { echo "Failed to update package lists after adding i386 architecture."; exit 1; }

# 安装Wine和Wine32
echo "Step 4: Installing Wine and Wine32..."
sudo apt-get install -y wine wine32 || { echo "Failed to install Wine and Wine32."; exit 1; }

# 安装winetricks
echo "Step 5: Installing winetricks..."
sudo apt-get install -y winetricks || { echo "Failed to install winetricks."; exit 1; }

# 使用winetricks安装字体和其他库
echo "Step 6: Installing fonts and libraries with winetricks..."
winetricks allfonts corefonts cjkfonts d3dx9 d3dx10 vcrun2022 || { echo "Failed to install fonts and libraries with winetricks."; exit 1; }

echo "Script execution completed."
