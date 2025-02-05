#!/bin/bash

DOCKER_USERNAME="mlopsadm"
DOCKER_GROUP="mlopsadm"
DOCKER_USER_HOME="/home/${DOCKER_USERNAME}"
DOCKER_DIR="/opt/docker"
DOCKER_COMPOSE_VERSION="2.11.2"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Create DOCKER_DIR directory and assign permissions
echo "Creating ${DOCKER_DIR} directory..."
sudo mkdir -p ${DOCKER_DIR}
sudo chown ${DOCKER_USERNAME}:${DOCKER_GROUP} ${DOCKER_DIR}
sudo chmod 755 ${DOCKER_DIR}
echo "${DOCKER_DIR} directory created and permissions assigned."

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Installing Docker..."

    # Update the package database
    sudo apt-get update

    # Install required packages
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the stable repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update the package database again
    sudo apt-get update

    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Verify that Docker Engine is installed correctly
    sudo docker run hello-world

    echo "Docker has been installed successfully."
else
    echo "Docker is already installed."
fi

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o ${DOCKER_DIR}/docker-compose
sudo chmod +x ${DOCKER_DIR}/docker-compose

# Add Docker Compose to PATH
echo "Adding Docker Compose to PATH..."
echo 'export PATH=$PATH:'"$DOCKER_DIR" >> ${DOCKER_USER_HOME}/.bashrc
source ${DOCKER_USER_HOME}/.bashrc

# Add DOCKER_USERNAME to sudo and docker groups if not root
if [ "$DOCKER_USERNAME" != "root" ] && [ "$DOCKER_GROUP" != "root" ]; then
    echo "Adding ${DOCKER_USERNAME} to sudo and docker groups..."
    sudo usermod -aG sudo,docker ${DOCKER_USERNAME}
    echo "User ${DOCKER_USERNAME} has been added to the sudo and docker groups."
fi

echo "Docker and Docker Compose have been installed and configured successfully."