#!/bin/bash

CURRENT_USER_HOME_FOLDER=/home/vagrant
WORKING_DIRECTORY=custom_nginx_vts

# Create Nginx directory
cd $CURRENT_USER_HOME_FOLDER || exit
mkdir ./$WORKING_DIRECTORY
cd ./$WORKING_DIRECTORY || exit

# Install core dependencies
sudo yum check-update
sudo yum install -y pcre-devel openssl-devel gcc curl zlib-devel wget unzip make git

# Download and unarchive Nginx source code
wget https://nginx.org/download/nginx-1.20.1.tar.gz
tar -xzvf nginx-1.20.1.tar.gz

# Clone VTS module repository
git clone https://github.com/vozlt/nginx-module-vts.git

# Compile Nginx
cp /vagrant/configure_vts.sh $CURRENT_USER_HOME_FOLDER/$WORKING_DIRECTORY/nginx-1.20.1/
cd $CURRENT_USER_HOME_FOLDER/$WORKING_DIRECTORY/nginx-1.20.1 || exit
./configure_vts.sh
sudo make && sudo make install

# Backup old Nginx conf file
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Create new Nginx conf file
sudo cp /vagrant/nginx.conf /etc/nginx/

# Create service file for Nginx
sudo cp /vagrant/nginx.service /lib/systemd/system

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable Nginx autostart
sudo systemctl enable nginx

# Start Nginx
sudo systemctl start nginx
