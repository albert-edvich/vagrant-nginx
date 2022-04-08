#!/bin/bash

# Install core dependencies
sudo yum check-update
sudo yum install -y epel-release

# Install Nginx
sudo yum install -y nginx

# Start Nginx
sudo systemctl start nginx

# Enable Nginx autostart
sudo systemctl enable nginx

# Nginx status
sudo systemctl status nginx
