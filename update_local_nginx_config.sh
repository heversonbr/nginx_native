#!/bin/bash

source .env

echo "Stoping nginx service..."
sudo systemctl stop nginx.service
echo "-------------------------------------------------------------"
echo "Creating directory in /var/www/..."
sudo mkdir -p $NGINX_HTTP_CONTENT_ROOT
echo "-------------------------------------------------------------"
echo "Backup 1st base-config file: $NGINX_BASE_CONFIG_DST"
if [ -f "$NGINX_BASE_CONFIG_DST_BKP" ]; then
    echo "$NGINX_BASE_CONFIG_DST_BKP: Already exists, skipping."
else
    sudo cp -p $NGINX_BASE_CONFIG_DST $NGINX_BASE_CONFIG_DST_BKP
fi 
echo "-------------------------------------------------------------"
echo "Copying base config file: $NGINX_BASE_CONFIG_DST"
sudo cp -p $NGINX_BASE_CONFIG_SRC $NGINX_BASE_CONFIG_DST
sudo chown root:root $NGINX_BASE_CONFIG_DST 
sudo chmod 644 $NGINX_BASE_CONFIG_DST
echo "-------------------------------------------------------------"

echo "Unlinking default config: $NGINX_DEFAULT_SERVER_ENABLE"
sudo unlink $NGINX_DEFAULT_SERVER_ENABLE 
# Note: sites-enable links to sites-available
echo "-------------------------------------------------------------"

echo "Backup server config file: $NGINX_DEFAULT_SERVER_AVAILABLE"
if [ -f "$NGINX_DEFAULT_SERVER_AVAILABLE_BKP" ]; then
    echo "$NGINX_DEFAULT_SERVER_AVAILABLE_BKP: Already exists, skipping."
else
    sudo cp -p $NGINX_DEFAULT_SERVER_AVAILABLE $NGINX_DEFAULT_SERVER_AVAILABLE_BKP
fi 
echo "-------------------------------------------------------------"
echo "Removing NGINX DEFAULT Site-Available configurations"
if [ -f "$NGINX_DEFAULT_SERVER_AVAILABLE" ]; then
    sudo rm $NGINX_DEFAULT_SERVER_AVAILABLE
fi 
echo "-------------------------------------------------------------"
echo "Copying server config file: $NGINX_SERVER_AVAILABLE_DST"
sudo cp -p  $NGINX_SERVER_AVAILABLE_SRC $NGINX_SERVER_AVAILABLE_DST
sudo chown root:root $NGINX_SERVER_AVAILABLE_DST
sudo chmod 644 $NGINX_SERVER_AVAILABLE_DST
echo "-------------------------------------------------------------"
echo "re-linking: $NGINX_SERVER_AVAILABLE_DST -> $NGINX_DEFAULT_SERVER_ENABLE"
sudo ln -s $NGINX_SERVER_AVAILABLE_DST $NGINX_DEFAULT_SERVER_ENABLE
echo "-------------------------------------------------------------"
echo "including proxy config"
if [ -d "/etc/nginx/includes/" ]; then
    echo "directory includes already exists."
else 
    sudo mkdir -p /etc/nginx/includes/
    sudo chown root:root /etc/nginx/includes/
fi
sudo cp -p  ./config/proxy.conf /etc/nginx/includes/proxy.conf
sudo chown root:root /etc/nginx/includes/proxy.conf
sudo chmod 644 /etc/nginx/includes/proxy.conf
echo "-------------------------------------------------------------"

#sudo rm /var/www/html/* 
sudo cp -p $NGINX_HTML_SRC $NGINX_HTML_DST

echo "testing config! "
sudo nginx -t
echo "---------------------------"
echo "Reload nginx service!"
echo "---------------------------"