#!/bin/bash

# this script takes a user's name and password to create a user with sudo privilage


# prompting user to enter a name
read -p 'Enter a User Name: ' NAME

# prompting user to enter a password (user will not see what they write)
read -sp 'Enter a Password: ' PASS

# echo NAME and PASS to see if they stored the input values
echo # for new line
echo ${NAME}
echo ${PASS}
