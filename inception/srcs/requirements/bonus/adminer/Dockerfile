# Base image
FROM debian:bullseye

# Update and upgrade system & install wget and php
RUN apt-get update && apt-get -y upgrade && apt-get install -y wget php7.4 php7.4-fpm

# Check if PHP-FPM is installed correctly
RUN which php-fpm7.4 || (echo "PHP-FPM not found" && exit 1)

# Expose port 9000
EXPOSE 9000

# Copy Entrypoint script
COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run php-fpm
ENTRYPOINT ["bash", "/usr/local/bin/entrypoint.sh"]
