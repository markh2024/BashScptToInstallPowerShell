#!/usr/bin/env bash

## insPowerShell.sh 
## Written by MD Harrington  For Debian (Bookworm) 64 bit achitecture 
## Tested on Debian 12 and  works like a charm 
## To Run do af follows 
## 1) Change to directory you dowloaded this to  type the following
## 2) chmod +x <name of file.sh> 
## 3) ./<name of file.sh> 
## All the rest is automatically done for you 

# Colors for output
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# Function to display colored messages
function print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${RESET}"
}

# Function to display the header
function display_header() {
    clear
    print_message "$YELLOW" "========================================"
    print_message "$YELLOW" " Script Written By MD Harrington"
    print_message "$YELLOW" " London Kent DA6 8NP"
    print_message "$YELLOW" " Please wait 2 seconds ..."
    print_message "$YELLOW" "========================================"
    sleep 2
}

# Call the header function
display_header

# 1) Check OS and version
print_message "$BLUE" "Checking system compatibility..."

OS_NAME=$(lsb_release -is 2>/dev/null || echo "Unknown")
OS_VERSION=$(lsb_release -cs 2>/dev/null || echo "Unknown")
ARCH=$(uname -m)

if [[ "$OS_NAME" != "Debian" || "$OS_VERSION" != "bookworm" || "$ARCH" != "x86_64" ]]; then
    print_message "$RED" "Script is written for Debian 12 (bookworm) 64-bit architecture."
    print_message "$YELLOW" "Proceed at your own risk!"
    exit 1
fi
print_message "$GREEN" "System check passed: Debian 12 (bookworm) 64-bit."

# 2) Update system and check for updates
print_message "$BLUE" "Updating package lists and checking for upgrades..."
sudo apt-get update && sudo apt-get upgrade -y
print_message "$GREEN" "System update completed successfully."

# 3) Install wget if not already installed
print_message "$BLUE" "Checking for wget..."
if ! command -v wget &> /dev/null; then
    print_message "$YELLOW" "wget not found. Installing wget..."
    sudo apt-get install -y wget
    print_message "$GREEN" "wget installed successfully."
else
    print_message "$GREEN" "wget is already installed."
fi

# 4) Download the PowerShell .deb file
DEB_URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell_7.4.6-1.deb_amd64.deb"
DEB_FILE="powershell_7.4.6-1.deb_amd64.deb"

print_message "$BLUE" "Downloading PowerShell .deb file..."
wget "$DEB_URL" -O "$DEB_FILE"

if [[ ! -f "$DEB_FILE" ]]; then
    print_message "$RED" "Download failed. Exiting script."
    exit 1
fi
print_message "$GREEN" "PowerShell .deb file downloaded successfully."

# 5) Create 'installs' directory
INSTALL_DIR="installs"

print_message "$BLUE" "Creating '$INSTALL_DIR' directory..."
mkdir -p "$INSTALL_DIR"

if [[ ! -d "$INSTALL_DIR" ]]; then
    print_message "$RED" "Failed to create directory '$INSTALL_DIR'. Exiting script."
    exit 1
fi
print_message "$GREEN" "'$INSTALL_DIR' directory created successfully."

# Move the downloaded file into the installs directory
print_message "$BLUE" "Moving PowerShell .deb file to '$INSTALL_DIR'..."
mv "$DEB_FILE" "$INSTALL_DIR/"

if [[ ! -f "$INSTALL_DIR/$DEB_FILE" ]]; then
    print_message "$RED" "Failed to move the .deb file. Exiting script."
    exit 1
fi
print_message "$GREEN" "File moved successfully."

# 6) Install PowerShell package
print_message "$BLUE" "Installing PowerShell package..."
cd "$INSTALL_DIR" || exit
sudo dpkg -i "$DEB_FILE"

# 7) Resolve missing dependencies
print_message "$BLUE" "Resolving missing dependencies..."
sudo apt-get install -f -y

print_message "$GREEN" "PowerShell installation completed successfully."

# 8) Delete the .deb file
print_message "$BLUE" "Cleaning up: Deleting PowerShell .deb file..."
rm "$DEB_FILE"

if [[ -f "$DEB_FILE" ]]; then
    print_message "$RED" "Failed to delete the .deb file. Please delete it manually."
else
    print_message "$GREEN" "Cleanup successful."
fi

# 9) Test PowerShell installation
print_message "$BLUE" "Testing PowerShell installation..."
pwsh --version

if [[ $? -eq 0 ]]; then
    print_message "$GREEN" "PowerShell installed successfully!"
    print_message "$YELLOW" "You can now run PowerShell by typing 'pwsh'."
else
    print_message "$RED" "PowerShell installation failed."
fi


## Links as follows 
## https://www.instagram.com/markukh2021/
## https://www.facebook.com/mark.harrington.14289/
## https://github.com/markh2024?tab=repositories
## https://pastebin.com/u/Mark2020H
## https://codeshare.io/9bxp67
