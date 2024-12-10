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
cd 
sudo mkdir /home/${NAME}

# Copying configuration files to user's home dir
sudo cp -r /etc/skel/. /home/${NAME}

# encrypting password
PASS_ENCRYPTED=$(echo -n "${PASS}" | sha256sum)

# echoing password to make sure it was encrypted successfully
print_status ${PASS_ENCRYPTED}
