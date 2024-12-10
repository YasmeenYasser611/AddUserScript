#!/bin/bash

# this script takes a user's name and password to create a user with sudo privilage

#concatenate user line to send to passwd
concat_passwd() {
symbol=":"
concatenated="$1$symbol$2$symbol$3$symbol$4$symbol$5$symbol$6$symbol$7"
# Print the result
echo "$concatenated">>/etc/passwd
}
concat_prim_group() {
#group_name:password:GID:user_list
symbol=":"
concatenated="$1$symbol$2$symbol$3$symbol$4"
# Print the result
echo "$concatenated">>/etc/group
}

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
INFO="$fullName,$roomNumber,$phoneNumber,$workNumber,$otherInfo"
HOME_DIR="/home/$NAME"
concat_passwd "$NAME" "X" "$FIRST_FREE_UID" "$FIRST_FREE_GID" "$INFO" "$HOME_DIR" "$SHELL" 
concat_prim_group "$NAME" "X" "$FIRST_FREE_GID"

