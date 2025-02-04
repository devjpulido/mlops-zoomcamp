#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "Uninstalling Docker..."

# Stop Docker service
sudo systemctl stop docker

# Uninstall Docker packages
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io

# Remove Docker dependencies
sudo apt-get autoremove -y --purge docker-ce docker-ce-cli containerd.io

# Remove Docker directories
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove Docker group
sudo groupdel docker

echo "Docker has been uninstalled and cleaned up successfully."