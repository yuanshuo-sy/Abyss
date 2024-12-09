#!/bin/bash

# 更新软件包列表
echo "Step 1: Updating package lists..."
sudo apt-get update

# 安装必要的软件包
echo "Step 2: Installing necessary packages..."
sudo apt-get install -y dirmngr ca-certificates curl software-properties-common apt-transport-https

# 添加i386架构支持
echo "Step 3: Adding i386 architecture..."
sudo dpkg --add-architecture i386
sudo apt-get update

# 安装Wine和Wine32
echo "Step 4: Installing Wine and Wine32..."
sudo apt-get install -y wine wine32

# 安装winetricks
echo "Step 5: Installing winetricks..."
sudo apt-get install -y winetricks

# 使用winetricks安装字体和其他库
echo "Step 6: Installing fonts and libraries with winetricks..."
winetricks allfonts corefonts cjkfonts d3dx9 d3dx10 vcrun2022

echo "Script execution completed."
