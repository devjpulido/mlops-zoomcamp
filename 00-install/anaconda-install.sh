#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Define Anaconda version and installation path
ANACONDA_VERSION="2023.03"
ANACONDA_USER_HOME="/root"
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

# Verify Anaconda installation
echo "Verifying Anaconda installation..."
conda --version

# Clean up
echo "Cleaning up..."
rm /tmp/anaconda.sh

echo "Anaconda has been installed and initialized successfully."