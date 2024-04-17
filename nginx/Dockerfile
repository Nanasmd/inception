# Base image
FROM 		debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG			DOMAIN_NAME
ARG 		CERTS_KEY
ARG			CERTS_CRT

# Update and upgrade system & install Nginx and OpenSSL
RUN 		apt -y update && apt -y upgrade
RUN 		apt -y install nginx openssl 

# Generate self-signed certificate
RUN 		openssl req -x509 -sha256 -nodes \
			-newkey rsa:4096 \
			-days 365 \
			-subj "/C=FR/ST=Ile-de-France/L=Paris/O=42Paris/OU=Inception/CN=nasamadi.42.fr" \
			-keyout ${CERTS_KEY} \
			-out ${CERTS_CRT} 

# Guarantee that Nginx is using TSLv1.3 
RUN 		sed -i 's/ssl_protocols.*/ssl_protocols TLSv1.3;/' /etc/nginx/nginx.conf

# Copy configuration files
COPY 		./conf/https.conf /etc/nginx/conf.d/
RUN			sed -i "s|nasamadi.42.fr|${DOMAIN_NAME}|g" /etc/nginx/conf.d/https.conf
RUN 		sed -i "s|/home/nasamadi/inception/srcs/requirements/nginx/certs/nginx-selfsigned.key|${CERTS_KEY}|g" /etc/nginx/conf.d/https.conf
RUN 		sed -i "s|I/home/nasamadi/inception/srcs/requirements/nginx/certs/nginx-selfsigned.crt|${CERTS_CRT}|g" /etc/nginx/conf.d/https.conf
COPY 		./conf/http.conf /etc/nginx/conf.d/
RUN			sed -i "s|nasamadi.42.fr|${DOMAIN_NAME}|g" /etc/nginx/conf.d/https.conf

# Expose ports
EXPOSE 		443

# Run NGINX
ENTRYPOINT	[ "nginx", "-g", "daemon off;" ]