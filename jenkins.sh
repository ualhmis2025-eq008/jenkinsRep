#!/bin/bash
#----------------------------------------------------
# Variables de configuración 
#----------------------------------------------------

DNS_NAME=ualfsp323jenkins.northeurope.cloudapp.azure.com

apt-get update -y
apt install openjdk-17-jdk -y

cp conf/environment /etc/environment
source /etc/environment
# echo $JAVA_HOME Para comprobar la variable de entorno

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
 https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
 /etc/apt/sources.list.d/jenkins.list > /dev/null
 
apt-get update -y
apt-get install jenkins -y

# sudo systemctl status jenkins para comprobar que el servicio jenkins esta activo

apt install nginx -y

cp conf/$DNS_NAME /etc/nginx/sites-available/
rm -rf /etc/nginx/sites-available/defaultsudo 
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/$DNS_NAME /etc/nginx/sites-enabled/default

cp conf/jenkins /etc/default/jenkins

systemctl restart jenkins
nginx -t
service nginx restart

apt-get install python3-certbot-nginx -y