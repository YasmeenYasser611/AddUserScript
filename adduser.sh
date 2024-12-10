#!/bin/bash

# This script takes a user's name and password to create a user with sudo privileges.

# Function to print user name and password for debugging purposes
print_usrAndPass() {
    echo # for new line
    echo "Username: ${NAME}"
    echo "Password: ${PASS}"
}

# Function to print status messages
print_status() {
    echo
    echo "$1"
}

# Prompting user to enter a name
read -p 'Enter a User Name: ' NAME

# Prompting user to enter a password (user will not see what they write)
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

echo 'Adding user information...'

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

# Find the first free UID
FIRST_FREE_UID=$(awk -F: -v min_uid=1000 '$3 >= min_uid {uids[$3]=1} END {for (i=min_uid; i<60000; i++) if (!uids[i]) {print i; exit}}' /etc/passwd)

# Find the first free GID
FIRST_FREE_GID=$(awk -F: -v min_gid=1000 '$3 >= min_gid {gids[$3]=1} END {for (i=min_gid; i<60000; i++) if (!gids[i]) {print i; exit}}' /etc/group)


# Manually adding the user to /etc/passwd
#print_status "Adding the user to /etc/passwd"
#sudo bash -c "echo '${NAME}:x:$FIRST_FREE_UID:$FIRST_FREE_GID:${fullName},${roomNumber},${phoneNumber},${workNumber},${otherInfo}:/home/${NAME}:/bin/bash' >> /etc/passwd"


# Adding the user to the sudoers group
#print_status "Granting sudo privileges to the user..."
#sudo bash -c "echo '${NAME} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"

#print_status "User ${NAME} created successfully with sudo privileges."

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
