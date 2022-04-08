#!/bin/bash
CURRENT_USER_HOME_FOLDER=/home/vagrant
WORKING_DIRECTORY=custom_nginx_lua

LUAJIT_LIB=/usr/local/lib \
LUAJIT_INC=/usr/local/include/luajit-2.1 \
./configure \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--user=nobody\
--group=nobody \
--with-pcre \
--with-file-aio \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_realip_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
--without-http_fastcgi_module ${NGINX_DEBUG:+--debug} \
--with-cc-opt=-O2 \
--with-ld-opt='-Wl,-rpath,/usr/local/lib' \
--add-module=$CURRENT_USER_HOME_FOLDER/$WORKING_DIRECTORY/ngx_devel_kit-0.3.1 \
--add-module=$CURRENT_USER_HOME_FOLDER/$WORKING_DIRECTORY/lua-nginx-module-0.10.19
