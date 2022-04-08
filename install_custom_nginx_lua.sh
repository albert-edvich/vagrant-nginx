#!/bin/bash

CURRENT_USER_HOME_FOLDER=/home/vagrant
WORKING_DIRECTORY=custom_nginx_lua

# Create Nginx directory
cd $CURRENT_USER_HOME_FOLDER || exit
mkdir ./$WORKING_DIRECTORY
cd ./$WORKING_DIRECTORY || exit

# Install core dependencies
sudo yum check-update
sudo yum install -y pcre-devel openssl-devel gcc curl zlib-devel wget unzip make git

# Add OpenResty YUM Repository
wget https://openresty.org/package/centos/openresty.repo
sudo mv openresty.repo /etc/yum.repos.d/

# # Install OpenResty
sudo yum check-update
sudo yum install -y openresty openresty-resty

# wget https://openresty.org/download/openresty-1.19.9.1.tar.gz

# Download and unarchive OpenResty Nginx Source Code Releases
wget https://openresty.org/download/nginx-1.19.3.tar.gz
tar -xzvf nginx-1.19.3.tar.gz

# Download and unarchive Nginx Development Kit (NDK)
wget -O nginx_devel_kit.tar.gz https://github.com/simpl/ngx_devel_kit/archive/v0.3.1.tar.gz
tar -xzvf nginx_devel_kit.tar.gz

# Download and unarchive Nginx Lua Module
wget -O nginx_lua_module.tar.gz https://github.com/openresty/lua-nginx-module/archive/v0.10.19.tar.gz
tar -xzvf nginx_lua_module.tar.gz

# Download and unarchive LuaJIT
wget -O luajit2.tar.gz https://github.com/openresty/luajit2/archive/v2.1-20201229.tar.gz
tar -xzvf luajit2.tar.gz

# Compile LuaJIT
cd luajit2-2.1-20201229 || exit
sudo make && sudo make install

# Compile Nginx
cp /vagrant/luajit.sh $CURRENT_USER_HOME_FOLDER/$WORKING_DIRECTORY/nginx-1.19.3/
cd $CURRENT_USER_HOME_FOLDER/$WORKING_DIRECTORY/nginx-1.19.3 || exit
./luajit.sh
sudo make && sudo make install

# Backup old Nginx conf file
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Create new Nginx conf file
sudo cp /vagrant/nginx.conf /etc/nginx/

# Copy LUA file
sudo cp /vagrant/test.lua /etc/nginx/

# Create service file for Nginx
sudo cp /vagrant/nginx.service /lib/systemd/system

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable Nginx autostart
sudo systemctl enable nginx

# Start Nginx
sudo systemctl start nginx
