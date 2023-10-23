#!/bin/bash

# Update the system
sudo apt-get update

# Install Apache, MySQL, PHP, and other necessary packages
sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql

# Clone the PHP application from GitHub
git clone https://github.com/laravel/laravel.git

# Configure Apache web server
sudo mv laravel /var/www/html/
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel

# Configure MySQL
sudo mysql -e "CREATE DATABASE laravel;"
sudo mysql -e "CREATE USER 'laravel'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON laravel.* TO 'laravel'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Restart Apache
sudo systemctl restart apache2