#!/bin/bash

# Variables
DOCKER_DIR="/usr/local/bin"
DOCKER_USER_HOME="/home/mlopsadm"
DOCKER_USERNAME="mlopsadm"

# Stop Docker service
echo "Stopping Docker service..."
sudo systemctl stop docker

# Remove Docker packages
echo "Removing Docker packages..."
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io

# Remove Docker Compose
echo "Removing Docker Compose..."
sudo rm -f ${DOCKER_DIR}/docker-compose

# Remove Docker Compose from PATH
echo "Removing Docker Compose from PATH..."
sed -i '/export PATH=\$PATH:'"$DOCKER_DIR"'/d' ${DOCKER_USER_HOME}/.bashrc
source ${DOCKER_USER_HOME}/.bashrc

# Remove Docker directories
echo "Removing Docker directories..."
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove DOCKER_USERNAME from sudo and docker groups if not root
if [ "$DOCKER_USERNAME" != "root" ] && [ "$DOCKER_GROUP" != "root" ]; then
    echo "Removing ${DOCKER_USERNAME} from sudo and docker groups..."
    sudo deluser ${DOCKER_USERNAME} sudo
    sudo deluser ${DOCKER_USERNAME} docker
    echo "User ${DOCKER_USERNAME} has been removed from the sudo and docker groups."
fi

echo "Docker and Docker Compose have been uninstalled and configuration has been rolled back successfully."