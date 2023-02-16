#!/bin/bash

# Color variables
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Clear the screen
clear

# ASCII art
cat << "EOF"
        ___     __________  _______   ________  _________   
       /   \   /  _____/  \/  /    |  \_____  \ \_   ___ \  
      /  ^  \ /   \  ____\  /|   |  |   /   |   \/    \  \/  
     /  /_\  \\    \_\  \   \|   |  |  /    |    \     \____ 
    /  _____  \\______  /___\ \___|  |__\_______  /\______  /
    \/     \/        \/     \/                 \/        \/ 

EOF

# Update the package list and redirect output to null
echo -e "${GREEN}Updating package list...${NC}"
sudo apt update > /dev/null 2>&1

# Upgrade the installed packages and redirect output to null
echo -e "${GREEN}Upgrading installed packages...${NC}"
sudo apt upgrade -y > /dev/null 2>&1

# Remove unnecessary packages and clean up and redirect output to null
echo -e "${GREEN}Removing unnecessary packages and cleaning up...${NC}"
sudo apt autoremove -y > /dev/null 2>&1
sudo apt autoclean > /dev/null 2>&1

echo -e "${YELLOW}Done!${NC}"
