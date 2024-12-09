#!/bin/bash

# 确保脚本以root权限运行
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# 记录日志
exec > >(tee -a install_docker.log) 2>&1

echo "Starting Docker installation script..."

# 移除已安装的Docker相关软件包
echo "Step 1: Removing existing Docker packages..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    if dpkg -l | grep -q $pkg; then
        sudo apt-get remove -y $pkg || { echo "Failed to remove $pkg."; exit 1; }
    else
        echo "$pkg is not installed."
    fi
done

# 更新软件包列表并添加Docker的GPG密钥和软件源
echo "Step 2: Updating package lists and adding Docker's GPG key and repository..."
sudo apt-get update || { echo "Failed to update package lists."; exit 1; }
sudo apt-get install -y ca-certificates curl || { echo "Failed to install ca-certificates and curl."; exit 1; }

# 创建密钥环目录
sudo install -m 0755 -d /etc/apt/keyrings

# 下载Docker的GPG密钥
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc || { echo "Failed to download Docker GPG key."; exit 1; }
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 添加Docker的APT源
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bullseye stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || { echo "Failed to add Docker repository."; exit 1; }

# 更新软件包列表
sudo apt-get update || { echo "Failed to update package lists after adding Docker repository."; exit 1; }

# 安装Docker CE和相关插件
echo "Step 3: Installing Docker CE and plugins..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || { echo "Failed to install Docker CE and plugins."; exit 1; }

# 检查Docker是否正确安装
echo "Step 4: Checking Docker installation..."
if docker run --name "test" hello-world; then
    echo "Docker is installed correctly."
    docker rm test
    docker rmi hello-world
else
    echo "Docker installation failed."
    exit 1
fi

echo "Script execution completed."
