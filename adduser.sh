#!/bin/bash

# this script takes a user's name and password to create a user with sudo privilage


# function to print user name and password for debugging purposes
print_usrAndPass() {
	echo # for new line
	echo ${NAME}
	echo ${PASS}
}

print_status() {
	echo
	echo $1
}

# prompting user to enter a name
read -p 'Enter a User Name: ' NAME

# prompting user to enter a password (user will not see what they write)
read -sp 'Enter a Password: ' PASS

# creating a home directory for the new user
print_status "Creating a Home Directory For New User"
sudo mkdir /home/${NAME}

# Copying configuration files to user's home dir
sudo cp /etc/skel/. /home/${HOME}

