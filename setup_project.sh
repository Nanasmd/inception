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

# Color variables for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Base directory variable
BASE_DIR="./project"

# Begin setup
echo -e "${GREEN}Setting up project structure...${NC}"

# Create project directories
mkdir -p "${BASE_DIR}/srcs/requirements/{bonus,mariadb/{conf,tools},nginx/{conf,tools},wordpress/{conf,tools}}"

# Create necessary files
touch "${BASE_DIR}/Makefile" \
      "${BASE_DIR}/srcs/docker-compose.yml" \
      "${BASE_DIR}/srcs/requirements/mariadb/conf/create_db.sh" \
      "${BASE_DIR}/srcs/requirements/nginx/conf/nginx.conf" \
      "${BASE_DIR}/srcs/requirements/wordpress/conf/wp-config-create.sh" \
      "${BASE_DIR}/srcs/requirements/{mariadb,nginx,wordpress}/Dockerfile" \
      "${BASE_DIR}/srcs/requirements/{mariadb,nginx,wordpress}/.dockerignore"

# Generate .dockerignore files content
echo -e ".git\n.env" > "${BASE_DIR}/srcs/requirements/mariadb/.dockerignore"
cp "${BASE_DIR}/srcs/requirements/mariadb/.dockerignore" "${BASE_DIR}/srcs/requirements/nginx/.dockerignore"
cp "${BASE_DIR}/srcs/requirements/mariadb/.dockerignore" "${BASE_DIR}/srcs/requirements/wordpress/.dockerignore"

# Create the .env file dynamically using $USER
echo -e "${YELLOW}Creating .env file...${NC}"
cat << EOF > "${BASE_DIR}/srcs/.env"
DOMAIN_NAME=$USER.42.fr
# certificates
CERTS_KEY=/etc/ssl/private/nginx-selfsigned.key
CERTS_CRT=/etc/ssl/certs/nginx-selfsigned.crt
# MySQL setup
MYSQL_DATABASE=WordpressDB
MYSQL_ROOT_PASSWORD=1234root4321
MYSQL_USER=$USER
MYSQL_PASSWORD=1234mysql4321
FTP_USER=$USER
FTP_PASSWORD=1234ftp4321
EOF

# Output final directory structure and .env content for verification
echo -e "${GREEN}Directory structure and files created successfully.${NC}\n"
echo -e "${YELLOW}Final project structure:${NC}"
tree "${BASE_DIR}" --dirsfirst
echo -e "\n${YELLOW}.env file content:${NC}"
cat "${BASE_DIR}/srcs/.env"

# Completion message
echo -e "\n${GREEN}Project setup complete!${NC}"
