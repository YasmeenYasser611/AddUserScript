
# Linux User Creation Script <img src="./README_Pic/logo-linux.png" alt="Custom Icon" width="60" height="70" align="center"/>

This script is designed to create a new user on a Linux system, manually adding the user to the `/etc/passwd`, `/etc/group`, and `/etc/sudoers` files. It also sets up the user's home directory, encrypts the user password and grants them sudo privileges.

## Script Features
- **Prompts for User Information:** Asks for a username, password, and additional user details.
- **Password Matching:** Ensures the password and its confirmation match.
- **Manual User Creation:** Appends the user details to system files (`/etc/passwd`, `/etc/group`, and `/etc/sudoers`).
- **Home Directory Creation:** Automatically creates a home directory for the user.
- **Password Encryption:**
Encrypting the user password.
- **Sudo Privileges**: Grants the user administrative access.

## Script Execution

### Step-by-Step Process

1. **Enter User Information**:
   - The script prompts the user to enter a **Username**, **Password**, and **Password Confirmation**. If the passwords do not match, it will allow the user to retry until both passwords match.

   ![Screenshot 1: Entering User Information](./README_Pic/Screen1.png)

2. **User Information Validation**:
   - The script asks for additional details such as **Full Name**, **Room Number**, **Phone Numbers**, etc., and requests confirmation that the information entered is correct.

   ![Screenshot 2: Entering and Confirming User Information](./README_Pic/Screen2.png)

3. **Creating the Home Directory**:
   - The script creates a home directory at `/home/username` and assigns the user ownership, appends the user's details to the `/etc/passwd`, `/etc/group`, and `/etc/sudoers` files to finalize user creation and grant sudo privileges.

   ![Screenshot 3: Home Directory Creation](./README_Pic/Screen3.png)

4. **Completion**:
   - The script outputs a message confirming that the user has been created successfully with sudo privileges.

   ![Screenshot 5: Script Completion Message](./README_Pic/Screen4.png)

5. **Checking `/etc/passwd`**:
   - After running the script, you can verify the new user’s entry by running the following command:
     ```bash
     cat /etc/passwd
     ```
   - The output should include the newly added user.

   ![Screenshot 6: Output of cat /etc/passwd](./README_Pic/Screen5.png)
   User is created successfully!

## Important Notes
- **Backup System Files**: Always back up the `/etc/passwd`, `/etc/group`, and `/etc/sudoers` files before running this script to prevent potential system issues.
- **Security Considerations**: Be cautious when manually modifying system files like `/etc/sudoers` and `/etc/passwd`. Incorrect entries may cause system issues or security vulnerabilities.

## License
This script was created by a group of students from the ITI intake 45. It is free to use and modify for educational purposes. If you use or distribute it, please give proper credit.
 
# Add User Script

