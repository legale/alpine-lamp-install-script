#!/bin/sh
#enable grep to highlight matches
echo alias grep=\'grep --color=auto\' >> /etc/profile
#apply changes
source /etc/profile

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

#Enable web server dir .htaaccess
echo -e "
<Directory /var/www/localhost/htdocs/>
\tAllowOverride All
</Directory>" >> /etc/apache2/conf.d/default.conf

#enable apache2 mod_rewrite.so module
sed -i -r 's/#(.*mod_rewrite.*)/\1/' /etc/apache2/httpd.conf
service apache2 restart


echo -e "Done!"
echo -e "LAMP is ready!\n\n"
echo -e "user: root\npassword: empty\nmariadb user: root\npassword: empty\n"

