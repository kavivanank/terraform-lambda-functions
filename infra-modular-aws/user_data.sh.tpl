#!bin/bash
yum install -y
yum install -y httpd

mkdir -p /var/www/html
echo "Hello from ${app_name}" > /var/www/html/index.html

systemctl enable httpd
systemctl start httpd