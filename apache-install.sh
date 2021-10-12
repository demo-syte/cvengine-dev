#! /bin/bash
sudo apt update -y
sudo apt install -y apache2 git zip unzip
sudo systemctl enable apache2
sudo systemctl start apache2
#echo "<h1>Welcome to CVENGINE ! AWS Infra created using Terraform in us-east-2 Region</h1>" | sudo tee /var/www/html/index.html
wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
unzip -o 2117_infinite_loop.zip
cp -r 2117_infinite_loop/* /var/www/html
systemctl restart apache2