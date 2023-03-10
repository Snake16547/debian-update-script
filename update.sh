#!/bin/bash

# Check if the user has root privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root.${NC}"
    exit 1
fi

# Clear
clear

# Color variables
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Update the package list and redirect output to null
echo -e "${GREEN}Updating package list...${NC}"
sudo apt update > /dev/null 2>&1

# Get the list of packages to be upgraded
echo -e "${GREEN}Checking for available upgrades...${NC}"
upgrade_list=$(apt list --upgradable 2>/dev/null | grep -v -e 'Listing...' -e 'packages are already' | cut -d '/' -f 1)
if [ -z "$upgrade_list" ]; then
    echo -e "${YELLOW}No upgrades available.${NC}"
else
    # Print the list of packages to be upgraded
    echo -e "${GREEN}The following packages will be upgraded:${NC}"
    echo -e "${BLUE}$upgrade_list${NC}"
fi

# Upgrade the installed packages with detailed and animated output
echo -e "${GREEN}Upgrading installed packages...${NC}"
last_line=""
while true; do
    new_line=$(sudo apt upgrade -y --quiet --assume-yes --fix-missing 2>&1 | tail -n 1)
    if [ "$new_line" == "$last_line" ]; then
        break
    fi
    last_line="$new_line"
    echo -ne "${BLUE}$last_line\r${NC}"
    sleep 0.1
done

# Remove unnecessary packages and clean up and redirect output to null
echo -e "${GREEN}Removing unnecessary packages and cleaning up...${NC}"
sudo apt autoremove -y > /dev/null 2>&1
sudo apt autoclean > /dev/null 2>&1

echo -e "${GREEN}The update process is complete.${NC}"
