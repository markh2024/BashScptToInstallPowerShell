# Aim and purpose of thhis Script 

### To automatically install power shell on Debian Linux with minimum fuss and stress using bash scripting 
### Written by MD Harrington  For Debian (Bookworm) 64 bit achitecture 
### Tested on Debian 12 and  works like a charm 
### To Run do af follows 
### 1) Change to directory you dowloaded this to  type the following
### 2) chmod +x <name of file.sh> 
### 3) ./<name of file.sh> 
### All the rest is automatically done for you Enjoy 



## Script Explanation and how this code works 

### Shebang line
```
#!/bin/bash

```
- This specifies that the script will be executed using the Bash shell.

### Color Codes
```
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

```
- These  are ANSI escape codes that  define different colors for text:
    - RED: Error or failure messages.
    - GREEN: Success messages.
    - YELLOW: Warnings or informational prompts.
    - BLUE: Progress or stage updates.
    - RESET: Resets text to default color.

### print_message Function

```
function print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${RESET}"
}
```
- This is a reusable function to display messages in colored text:
    - $1 is the first argument (color).
    - $2 is the second argument (message).
    - echo -e enables escape sequences like color codes.
  
### Example Usage:
```
print_message "$RED" "This is an error message."
```

### display_header Function

```
function display_header() {
    clear
    print_message "$YELLOW" "========================================"
    print_message "$YELLOW" " Script Written By MD Harrington"
    print_message "$YELLOW" " London Kent DA6 8NP"
    print_message "$YELLOW" " Please wait 2 seconds ..."
    print_message "$YELLOW" "========================================"
    sleep 2
}
```

- This function displays a formatted header:
    - clear: Clears the terminal for a clean output.
    - print_message: Displays each line of the header in yellow.
    - sleep 2: Pauses the script for 2 seconds to give users time to read the header

### Call the Header

```
display_header
``` 
- Executes the display_header function at the start of the script.


###  Check OS and System Compatibility

```
OS_NAME=$(lsb_release -is 2>/dev/null || echo "Unknown")
OS_VERSION=$(lsb_release -cs 2>/dev/null || echo "Unknown")
ARCH=$(uname -m)
```
- lsb_release: Retrieves distribution information.
    - -is: Gets the OS name.
    - -cs: Gets the codename (e.g., "bookworm").
    - 2>/dev/null: Suppresses error output if lsb_release isn't available.
- uname -m: Returns the system architecture (e.g., "x86_64" for 64-bit).

### Conditional Check

```
if [[ "$OS_NAME" != "Debian" || "$OS_VERSION" != "bookworm" || "$ARCH" != "x86_64" ]]; then
    print_message "$RED" "Script is written for Debian 12 (bookworm) 64-bit architecture."
    print_message "$YELLOW" "Proceed at your own risk!"
    exit 1
fi

```
- Checks if the OS name, version, and architecture are as expected.
- If not, the script then does the following :

    - Displays a red error message.
    - Warns the user with a yellow message.
    - Exits the script using exit 1.

### Update and Upgrade System

```
sudo apt-get update && sudo apt-get upgrade -y
```

- apt-get update: Updates the package index.
- apt-get upgrade -y: Installs available updates automatically.

###  Check and Install wget

```
if ! command -v wget &> /dev/null; then
    print_message "$YELLOW" "wget not found. Installing wget..."
    sudo apt-get install -y wget
    print_message "$GREEN" "wget installed successfully."
else
    print_message "$GREEN" "wget is already installed."
fi
```

- command -v wget: Checks if wget is installed.
- If not then  what this does is this : 
    - Installs wget using apt-get install.
    - Displays success messages.

### Download PowerShell .deb File

```
DEB_URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell_7.4.6-1.deb_amd64.deb"
DEB_FILE="powershell_7.4.6-1.deb_amd64.deb"

wget "$DEB_URL" -O "$DEB_FILE"
```

- Downloads the PowerShell .deb package:
    - -O: Saves the file with the specified name.

### Check if Download Succeeded

```
if [[ ! -f "$DEB_FILE" ]]; then
    print_message "$RED" "Download failed. Exiting script."
    exit 1
fi
```
- Verifies if the downloaded file exists using -f.

### Create and Verify installs Directory

```
INSTALL_DIR="installs" ## you can change this to what ever you wish
## by your command meine fuhrer 

mkdir -p "$INSTALL_DIR"
if [[ ! -d "$INSTALL_DIR" ]]; then
    print_message "$RED" "Failed to create directory '$INSTALL_DIR'. Exiting script."
    exit 1
fi
```

- mkdir -p: Creates the directory if it doesn't exist.
- Verifies if the directory was created successfully.

###   Move the .deb File

```
mv "$DEB_FILE" "$INSTALL_DIR/"
```

- Moves the downloaded .deb file into the installs directory.

### Install PowerShell

```
cd "$INSTALL_DIR" || exit
sudo dpkg -i "$DEB_FILE"
```

- Changes to the installs directory.
- Installs the .deb file using dpkg -i.

### Resolve Missing Dependencies

```
sudo apt-get install -f -y
```
- Resolves any missing dependencies that dpkg reported.

### Delete the .deb File

```
rm "$DEB_FILE"
```
- Deletes the downloaded .deb file to clean up.

### Verify Deletion

``` 
if [[ -f "$DEB_FILE" ]]; then
    print_message "$RED" "Failed to delete the .deb file. Please delete it manually."
else
    print_message "$GREEN" "Cleanup successful."
fi
```
- Ensures the file was successfully removed.

###  Test PowerShell Installation

```
pwsh --version

```
- Runs PowerShell's version command to confirm the installation.

### Check if Successful

```
if [[ $? -eq 0 ]]; then
    print_message "$GREEN" "PowerShell installed successfully!"
    print_message "$YELLOW" "You can now run PowerShell by typing 'pwsh'."
else
    print_message "$RED" "PowerShell installation failed."
fi
```

- $? checks the exit status of the last command:
    - 0 means success.
    - Non-zero indicates an error.

## Final Notes
### Im summary this script performs  the following : 
- Validates the OS to ensure compatibility.
- Updates and installs dependencies safely.
- Downloads, verifies, and installs PowerShell.
- Provides clear, colored messages at each step for better user experience.
- Cleans up temporary files after the installation.



#### Thanks for reading and now can see just how much is missing  from scripts on line  where as what Ive uploaded explains all  line by line 

####  Cheers and have an excellent Xmas and learn as much as you can as that world out there is changing fast , faster than you could  ever picture Its not going to wait for you  !! 





