# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup_project.sh                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nasamadi <nasamadi@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/13 13:32:35 by nasamadi          #+#    #+#              #
#    Updated: 2024/03/13 14:04:30 by nasamadi         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Define the base directory
BASE_DIR=$(pwd)
echo -e "${YELLOW}Initializing project structure in ${BASE_DIR}${NC}"

# Create the main project directory and subdirectories
echo -e "${GREEN}Creating project directories...${NC}"
mkdir -p "$BASE_DIR/srcs/requirements/bonus"
mkdir -p "$BASE_DIR/srcs/requirements/mariadb" "$BASE_DIR/srcs/requirements/nginx" "$BASE_DIR/srcs/requirements/wordpress"

# Create subdirectories for bonus services
mkdir -p "$BASE_DIR/srcs/requirements/bonus/adminer" "$BASE_DIR/srcs/requirements/bonus/cadvisor" "$BASE_DIR/srcs/requirements/bonus/ftp-server" "$BASE_DIR/srcs/requirements/bonus/redis-cache" "$BASE_DIR/srcs/requirements/bonus/static-website"

# Create tool and config directories within services
for SERVICE in mariadb nginx wordpress adminer cadvisor ftp-server redis-cache static-website; do
  echo -e "${YELLOW}Setting up directories for${NC} $SERVICE..."
  mkdir -p "$BASE_DIR/srcs/requirements/$SERVICE/tools"
  mkdir -p "$BASE_DIR/srcs/requirements/$SERVICE/conf"
done

# Create the .env file
echo -e "${GREEN}Creating .env file...${NC}"
cat << EOF > "$BASE_DIR/srcs/.env"
DOMAIN_NAME=nasamadi.42.fr
# certificates
CERTS_KEY=/etc/ssl/private/nginx-selfsigned.key
CERTS_CRT=/etc/ssl/certs/nginx-selfsigned.crt
# MySQL setup
MYSQL_DATABASE=WordpressDB
MYSQL_ROOT_PASSWORD=1234root4321
MYSQL_USER=nasamadi
MYSQL_PASSWORD=1234mysql4321
FTP_USER=nasamadi
FTP_PASSWORD=1234ftp4321
EOF

# Create a basic Makefile
echo -e "${GREEN}Creating Makefile...${NC}"
cat << EOF > "$BASE_DIR/Makefile"
all:
	@echo "Placeholder for Makefile commands"
EOF

# Create a basic docker-compose.yml file
echo -e "${GREEN}Creating docker-compose.yml...${NC}"
cat << EOF > "$BASE_DIR/srcs/docker-compose.yml"
version: '3'

services:
  nginx:
    build: ./requirements/nginx
    container_name: nginx
    volumes:
      - ./data/nginx:/data/nginx
    ports:
      - "443:443"
    networks:
      - net

networks:
  net:
EOF

echo -e "${GREEN}Project structure setup complete.${NC}"
