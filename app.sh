#!/bin/bash
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
echo "Welcome to My Page" | sudo tee /var/www/html/index.html
