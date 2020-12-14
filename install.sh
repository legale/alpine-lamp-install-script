#!/bin/bash

# apk update && apk upgrade
apk update && apk upgrade
apk add --no-cache openssh

# root login
sed -i s/.PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config
sed -i s/.PermitEmptyPasswords.*/PermitEmptyPasswords\ yes/ /etc/ssh/sshd_config

service sshd restart

