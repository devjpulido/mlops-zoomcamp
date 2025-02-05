#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Define Anaconda version and installation path
ANACONDA_USERNAME="mlopsadm"
ANACONDA_GROUP="mlopsadm"
ANACONDA_VERSION="2023.03"
ANACONDA_USER_HOME="/home/mlopsadm"
INSTALL_PATH="/opt/anaconda"

# Download Anaconda installer
echo "Downloading Anaconda installer..."
wget https://repo.anaconda.com/archive/Anaconda3-$ANACONDA_VERSION-Linux-x86_64.sh -O /tmp/anaconda.sh

# Install Anaconda silently
echo "Installing Anaconda..."
bash /tmp/anaconda.sh -b -p $INSTALL_PATH

# Initialize Anaconda
echo "Initializing Anaconda..."
$INSTALL_PATH/bin/conda init --all

# Activate Anaconda
echo "Activating Anaconda..."
source $INSTALL_PATH/bin/activate

# Reload bash profile
echo "Reloading bash profile..."
source ${ANACONDA_USER_HOME}/.bashrc

# Change the group ownership to ANACONDA_GROUP on the entire directory where Anaconda is installed.
sudo chgrp -R ${ANACONDA_GROUP} ${INSTALL_PATH} 

# Set read and write permission for the owner, root, and the ANACONDA_GROUP only.
sudo chmod 770 -R ${INSTALL_PATH}

# Add user to group if not already added
if ! id -nG ${ANACONDA_USERNAME} | grep -qw ${ANACONDA_GROUP}; then
    echo "Adding user ${ANACONDA_USERNAME} to group ${ANACONDA_GROUP}..."
    sudo usermod -aG ${ANACONDA_GROUP} ${ANACONDA_USERNAME}
else
    echo "User ${ANACONDA_USERNAME} is already a member of group ${ANACONDA_GROUP}."
fi

# Verify Anaconda installation
echo "Verifying Anaconda installation..."
conda --version

# Clean up
echo "Cleaning up..."
rm /tmp/anaconda.sh

echo "Anaconda has been installed and initialized successfully."