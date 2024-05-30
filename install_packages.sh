# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install_packages.sh                                :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nasamadi <nasamadi@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/13 13:15:28 by nasamadi          #+#    #+#              #
#    Updated: 2024/03/13 13:29:17 by nasamadi         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if the script is running as root
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}This script must be run as root. Please switch to root.${NC}" 1>&2
   exit 1
fi

echo -e "${GREEN}Starting the setup...${NC}"

# Install required packages
echo -e "${YELLOW}Installing required packages...${NC}"
apt-get update -y && apt-get update -y
apt-get install -y sudo apt-transport-https ca-certificates curl software-properties-common git make snapd systemd docker-compose openssh-server ufw build-essential dkms linux-headers-$(uname -r)

# Install Visual Code 
echo -e "${YELLOW}Installing Visual Code...${NC}"
apt-get update -y && apt-get update -y
snap install --classic code

# Clipboard setup
echo -e "${YELLOW}Installing required packages for bidirectional copy paste...${NC}"
apt-get update -y && apt-get update -y
mkdir -p /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
cd /mnt/cdrom
sh ./VBoxLinuxAdditions.run
adduser $USER vboxsf
echo -e "${YELLOW}In your VirtualBox window (with the Debian VM selected but not running), navigate to Settings > General > Advanced.${NC}"

# Grant execution permissions to the Docker Compose binary
echo -e "${YELLOW}Setting up Docker Compose...${NC}"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y && apt-get update -y
apt install docker-ce docker-ce-cli containerd.io -y
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Display installed versions
echo -e "${GREEN}Docker versions installed:${NC}"
docker --version
docker compose --version
docker-compose --version

# Configure Docker to not stop containers on service restart
echo -e "${YELLOW}Configuring Docker for live-restore...${NC}"
mkdir -p /etc/docker
bash -c 'echo "{\n\t\"live-restore\": true\n}" > /etc/docker/daemon.json'
systemctl restart docker

# Add the current user to the root, sudo and Docker group
echo -e "${YELLOW}Adding $USER to the root, sudo and Docker group...${NC}"
usermod -aG sudo,docker,root $USER

# Ensure Docker runs properly with a simple test
echo -e "${YELLOW}Running Docker hello-world to ensure proper setup...${NC}"
docker run hello-world

# Configuring SSH
echo -e "${YELLOW}Configuring SSH...${NC}"
SSHD_CONFIG="/etc/ssh/sshd_config"

# Change SSH port to 4242 and enable root login and password authentication
sed -i '/^#Port 22/c\Port 4242' $SSHD_CONFIG
sed -i '/^#PermitRootLogin prohibit-password/c\PermitRootLogin yes' $SSHD_CONFIG
sed -i '/^#PasswordAuthentication yes/c\PasswordAuthentication yes' $SSHD_CONFIG

# Restart SSH and SSHD services
echo -e "${YELLOW}Restarting SSH services...${NC}"
systemctl restart ssh
systemctl restart sshd

# Configuring UFW firewall
echo -e "${YELLOW}Configuring UFW firewall...${NC}"
ufw enable
ufw allow 4242
ufw allow 80
ufw allow 443
echo -e "${GREEN}UFW status:${NC}"
ufw status

# Inform the user about manual steps
echo -e "${GREEN}SSH and UFW configuration completed.${NC}"
echo -e "${YELLOW}Please perform port forwarding in your virtual machine settings manually.${NC}"

# Update /etc/hosts with your domain
echo -e "${YELLOW}Updating /etc/hosts with your domain...${NC}"
echo "127.0.0.1 $USER.42.fr" | sudo tee -a /etc/hosts

echo -e "${GREEN}Setup complete. Your system is now configured.${NC}"
echo -e "${RED}You need to reboot.${NC}"
