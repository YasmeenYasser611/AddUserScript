#!/bin/bash

# This script takes a user's name and password to create a user with sudo privileges.

# function to print status messages
print_status() {
    echo
    echo "$1"
}

# Function to add the user to /etc/shadow
concat_shadow() {
    	# username:password:lastchg:min:max:warn:inactive:expire
    	local USERNAME=$1
    	local PASSWORD=$2
    	local LASTCHG=0  	# Last password change (0 means force password change at first login)
    	local MIN_DAYS=0 	# Minimum days before a password change
    	local MAX_DAYS=99999 	# Maximum days the password is valid
    	local WARN_DAYS=7    	# Days to warn user before password expires
    	local INACTIVE=""     	# Account inactive period (empty means no limit)
    	local EXPIRE=""       	# Account expiration date (empty means no limit)
    	local SYMBOL=":"
	
	# concatenate relevant fields into one string 
    	local CONCATENATED="${USERNAME}${SYMBOL}${PASSWORD}${SYMBOL}${LASTCHG}${SYMBOL}${MIN_DAYS}${SYMBOL}${MAX_DAYS}${SYMBOL}${WARN_DAYS}${SYMBOL}${INACTIVE}${SYMBOL}${EXPIRE}"
	
	# echo string into shadow
    	sudo echo "$CONCATENATED" >> /etc/shadow
}

# concatenate user line to send to /etc/passwd file
concat_passwd() {
	symbol=":"
	PASSWD_STR="$1$symbol$2$symbol$3$symbol$4$symbol$5$symbol$6$symbol$7"

	# echoing string into passwd
	print_status "Adding ${NAME} to /etc/passwd..."
	echo ${PASSWD_STR} >> /etc/passwd
}

# concatenate group line to send to /etc/group
concat_prim_group() {
	symbol=":"
	GROUP_STR="$1$symbol$2$symbol$3$symbol$4"

	# echoing string into /etc/group
	print_status "Adding ${NAME}'s Group..."
	echo ${GROUP_STR} >> /etc/group

}

# force user to run the script as root or with sudo privilages
if [ ! "`whoami`" = "root" ] 
then
	echo 
    	echo "Please run script as root or using sudo."
    	exit 1
fi


# finding the first free UID
FIRST_FREE_UID=$(awk -F: -v min_uid=1000 '$3 >= min_uid {uids[$3]=1} END {for (i=min_uid; i<60000; i++) if (!uids[i]) {print i; exit}}' /etc/passwd)

# finding the first free GID
FIRST_FREE_GID=$(awk -F: -v min_gid=1000 '$3 >= min_gid {gids[$3]=1} END {for (i=min_gid; i<60000; i++) if (!gids[i]) {print i; exit}}' /etc/group)


# prompting user to enter a name
read -p 'Enter a User Name: ' NAME

# prompting user to enter a password (user will not see what they write)
while true; do
    read -sp 'Enter user Password: ' PASS
    echo # Add a new line after password input
    read -sp 'Re-enter the Password: ' RPASS
    echo # Add a new line after re-entering password

    if [ "$PASS" == "$RPASS" ]; then
        break
    else
        echo "Password does not match!"
        read -p 'Do you want to try again? [yes/no]: ' option
        if [ "$option" != "yes" ]; then
            echo "Exiting script."
            exit 1
        fi
    fi
done


print_status "Adding user information..."

correctInfo="no"
while [ "$correctInfo" != "yes" ]; do
    echo 'Enter your values or press Enter for default values'
    read -p 'User Full Name: ' fullName
    read -p 'Room Number: ' roomNumber
    read -p 'Personal Phone Number: ' phoneNumber
    read -p 'Work Phone Number: ' workNumber
    read -p 'Other info: ' otherInfo

    echo "Review the entered information:"
    echo "Full Name: ${fullName}"
    echo "Room Number: ${roomNumber}"
    echo "Personal Phone Number: ${phoneNumber}"
    echo "Work Phone Number: ${workNumber}"
    echo "Other Info: ${otherInfo}"

    read -p 'Is your info correct? [yes/no]: ' correctInfo
done

# Manually adding the user to /etc/passwd
#print_status "User ${NAME} created successfully with sudo privileges."

# creating a home directory for the new user
print_status "Creating a Home Directory For ${NAME}"
HOME_DIR="/home/$NAME"
cd 
sudo mkdir /home/${NAME}

# Copying configuration files to user's home dir
print_status "Copying Configurations Files for ${NAME} from /etc/skel..."
sudo cp -r /etc/skel/. /home/${NAME}

# generate the encrypted password using openssl
PASS_ENCRYPTED=$(openssl passwd -6 "$PASS")

# Add the user's password to /etc/shadow
print_status "Adding User Password to /etc/shadow..."
concat_shadow "$NAME" "$PASS_ENCRYPTED"

# appending extra info into one string
INFO="$fullName,$roomNumber,$phoneNumber,$workNumber,$otherInfo"

# concatenating all fields required for /etc/passwd
concat_passwd "$NAME" "x" "$FIRST_FREE_UID" "$FIRST_FREE_GID" "$INFO" "$HOME_DIR" "$SHELL" 

# concatenating all fields required for /etc/group
concat_prim_group "$NAME" "x" "$FIRST_FREE_GID"

# echoing string into passwd
print_status "Adding ${NAME} to /etc/passwd..."
echo ${concat_passwd} >> /etc/passwd

# echoing string into /etc/group
print_status "Adding ${NAME}'s Group..."
echo ${concat_prim_group} >> /etc/group

# print exit message
print_status "Done!"

# adding the user to the sudoers group
#print_status "Granting sudo privileges to the user..."
#sudo bash -c "echo '${NAME} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"


