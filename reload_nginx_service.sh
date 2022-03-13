#!/bin/bash

sudo systemctl stop nginx.service
sleep 0.5
sudo systemctl status  nginx | grep -v systemd

sudo systemctl start nginx.service
sleep 0.5
sudo systemctl status  nginx | grep -v systemd