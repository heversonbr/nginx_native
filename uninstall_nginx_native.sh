#!/bin/bash

#sudo apt-get update
sudo rm /var/www/html/*
sudo apt-get remove nginx -y 
sudo apt-get purge nginx -y
#sudo apt-get remove nginx-common -y 
#sudo apt-get purge nginx-common -y
sudo apt autoremove -y
#sudo dpkg --list |grep nginx
sudo dpkg --list |grep nginx |grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge
sudo dpkg --list |grep nginx