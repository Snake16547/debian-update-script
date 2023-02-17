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

# Upgrade the installed packages with detailed and animated output
echo -e "${GREEN}Upgrading installed packages...${NC}"
echo -e "${BLUE}[${NC}                    ${BLUE}]${NC} 0% completed"
sudo apt upgrade -y 2>&1 | while read -r line; do
    echo -e "${BLUE}[${NC}${line:0:20}${BLUE}]${NC} ${line:20}"
done | whiptail --title "Updating Packages" --gauge "Please wait..." 8 50 0

# Remove unnecessary packages and clean up and redirect output to null
echo -e "${GREEN}Removing unnecessary packages and cleaning up...${NC}"
sudo apt autoremove -y > /dev/null 2>&1
sudo apt autoclean > /dev/null 2>&1

echo -e "${YELLOW}Done!${NC}"
