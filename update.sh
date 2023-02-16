#!/bin/bash

# Color variables
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ASCII art
cat << "EOF"
        ___     __________  _______   ________  _________   
       /   \   /  _____/  \/  /    |  \_____  \ \_   ___ \  
      /  ^  \ /   \  ____\  /|   |  |   /   |   \/    \  \/  
     /  /_\  \\    \_\  \   \|   |  |  /    |    \     \____ 
    /  _____  \\______  /___\ \___|  |__\_______  /\______  /
    \/     \/        \/     \/                 \/        \/ 

EOF

# Update the package list
echo -e "${GREEN}Updating package list...${NC}"
sudo apt update

# Upgrade the installed packages
echo -e "${GREEN}Upgrading installed packages...${NC}"
sudo apt upgrade -y

# Remove unnecessary packages and clean up
echo -e "${GREEN}Removing unnecessary packages and cleaning up...${NC}"
sudo apt autoremove -y
sudo apt autoclean

echo -e "${YELLOW}Done!${NC}"
