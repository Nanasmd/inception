#!/bin/bash

# Set up php-fpm
mkdir -p /var/run/php
echo "Modifying PHP-FPM to listen on 0.0.0.0:9000..."
sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# Set up adminer
echo "Setting up Adminer..."
mkdir -p /var/www/html
wget "http://www.adminer.org/latest.php" -O /var/www/html/adminer.php
chown www-data:www-data /var/www/html/adminer.php
chmod 755 /var/www/html/adminer.php

# Check if PHP-FPM binary is accessible
which php-fpm7.4 || (echo "php-fpm7.4 not found in PATH" && exit 1)

# Start php-fpm
echo "Starting PHP-FPM..."
php-fpm7.4 -F
