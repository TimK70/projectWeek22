#!/bin/bash

sudo yum update
sudo yum install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo su
echo "Hello, Green Team!! from $(hostname -f)" > /var/www/html/index.html