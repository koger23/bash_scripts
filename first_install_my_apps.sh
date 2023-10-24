#!/bin/bash

# Declare an array of URLs for .deb files
declare -a app_urls=(
  "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"    # VS Code
  "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"   # Google Chrome
  "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_118.0.2088.61-1_amd64.deb?brand=M102"
  "https://dl.discordapp.net/apps/linux/0.0.32/discord-0.0.32.deb"
  "https://repo.steampowered.com/steam/archive/precise/steam_latest.deb"
)

declare -a apps_with_packagemngr=(
  "audacity"
  "flameshot"
  "git"
  "filezilla"
  "owncloud-client"
  "gimp"
)

# Define the temporary directory path
temp_dir="/tmp/deb_downloads"

# Create the temporary directory if it doesn't exist
if [ ! -d "$temp_dir" ]; then
  echo -e "Creating temporary directory...\n"
  mkdir -p "$temp_dir"
fi

# Change directory to the temporary directory
cd "$temp_dir" || exit

echo -e "\nStarting to download and install applications..."

counter=0
# Iterate through the array of URLs and download the .deb files
for url in "${app_urls[@]}"; do
  filename=$(echo "$url" | awk -F/ '{print $3}')

  echo -e "\nDownloading installer..."
  wget -q --show-progress "$url" -O $filename

  echo -e "\nInstalling..."
  sudo dpkg -i --skip-same-version $filename
  
  echo -e "\nDeleting '.deb' file...\n"
  # Clean up: delete the downloaded .deb file
  rm $filename
  counter=$((counter + 1))
done

# Install apps with packagemanager
for app in "${apps_with_packagemngr[@]}"; do
  sudo apt install $app
done

echo -e "\nAll done. Enyoj!"
