#!/bin/bash

sudo apt-get update
sudo apt-get install nginx  -y 
sudo systemctl start nginx
sudo systemctl enable nginx
sudo dpkg --list | grep nginx