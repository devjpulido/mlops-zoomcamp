#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Define Anaconda installation path and user details
ANACONDA_USERNAME="mlopsadm"
ANACONDA_GROUP="mlopsadm"
ANACONDA_USER_HOME="/home/mlopsadm"
INSTALL_PATH="/opt/anaconda"

# Deactivate Anaconda
echo "Deactivating Anaconda..."
conda deactivate

# Remove Anaconda installation directory
echo "Removing Anaconda installation directory..."
sudo rm -rf $INSTALL_PATH

# Remove Anaconda initialization from bash profile
echo "Removing Anaconda initialization from bash profile..."
sed -i '/# >>> conda initialize >>>/,/# <<< conda initialize <<</d' ${ANACONDA_USER_HOME}/.bashrc

# Reload bash profile
echo "Reloading bash profile..."
source ${ANACONDA_USER_HOME}/.bashrc

# Remove user from group if exists
if id -nG ${ANACONDA_USERNAME} | grep -qw ${ANACONDA_GROUP}; then
    echo "Removing user ${ANACONDA_USERNAME} from group ${ANACONDA_GROUP}..."
    sudo deluser ${ANACONDA_USERNAME} ${ANACONDA_GROUP}
else
    echo "User ${ANACONDA_USERNAME} is not a member of group ${ANACONDA_GROUP}."
fi

# Clean up any remaining files
echo "Cleaning up remaining files..."
rm -f /tmp/anaconda.sh

echo "Anaconda has been uninstalled and cleaned up successfully."