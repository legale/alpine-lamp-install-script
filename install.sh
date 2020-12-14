#!/bin/sh

# apk update && apk upgrade
apk update && apk upgrade
apk add openssh

# allow root login and empty password
sed -i s/.PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config
sed -i s/.PermitEmptyPasswords.*/PermitEmptyPasswords\ yes/ /etc/ssh/sshd_config

service sshd restart

# enable community repo
sed -i -r 's/#(.*\d\/community.*)/\1/' /etc/apk/repositories
apk update && apk upgrade

#install virtualbox-guest-additions
apk add virtualbox-guest-additions

#enable vboxsf module
modprobe -a vboxsf
echo vboxsf >> /etc/modules

# install LAMP packages
apk add php php-cli apache2 php-apache2 phpmyadmin mariadb mariadb-client


#allow apache user to read phpmyadmin config
chown root:apache /etc/phpmyadmin/config.inc.php
#allow allow empty password
sed -i -r 's/(.*AllowNoPassword.*=).*/\1 true;/' /etc/phpmyadmin/config.inc.php


#setup and start mariadb
service mariadb setup
service mariadb start

#set db root user empty password
mysqladmin --user=root password ""


#enable apache2 mod_rewrite.so module
sed -i -r 's/#(.*\d\/mod_rewrite.*)/\1/' /etc/apache2/httpd.conf


