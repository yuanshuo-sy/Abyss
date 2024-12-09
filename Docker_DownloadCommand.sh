#!/bin/bash

# 提升权限
echo "Step 1: Elevating privileges..."
sudo su

# 移除已安装的Docker相关软件包
echo "Step 2: Removing existing Docker packages..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove -y $pkg
done

# 更新软件包列表并添加Docker的GPG密钥和软件源
echo "Step 3: Updating package lists and adding Docker's GPG key and repository..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  bullseye stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# 安装Docker CE和相关插件
echo "Step 4: Installing Docker CE and plugins..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 检查Docker是否正确安装
echo "Step 5: Checking Docker installation..."
docker run --name "test" hello-world
docker rm test
docker rmi hello-world

echo "Script execution completed."
