#!/usr/bin/env bash

function confirmation_prompt() {
    read -p "$1 (y/n) " yn
    case $yn in 
        [yY] ) ;;
        [nN] ) echo exiting...;
            exit;;
        * ) echo invalid response;;
    esac
}

echo "--------------------------"
echo " Ubuntu post-installation"
echo "--------------------------"
confirmation_prompt "Do you want to run the script now?"

# ---------------------------------------------------
# Creating folder structure
# ---------------------------------------------------
echo "➜ Creating folder structure"
# Folder for projects (other than source code)
mkdir -pv $HOME/projects
# Folder for bash 'general use' scripts
mkdir -pv $HOME/scripts
# Folder for source code and repos
mkdir -pv $HOME/src

# ---------------------------------------------------
# APT package installation
# ---------------------------------------------------
PACKAGE_LIST=(
	vlc
	vlc-plugin-access-extra
	htop
	gnome-tweaks
	python3
	neofetch
	nmap
	wget
	java-latest-openjdk
	heif-gdk-pixbuf
	codium
)

# Add respositiories
echo "➜ Add repositories"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg 
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list 

# update repositories
echo "➜ Updating repositories"
sudo apt-get update -yq

# iterate through packages and install them if not already installed
for package_name in ${PACKAGE_LIST[@]}; do
	if ! sudo apt list --installed | grep -q "^\<$package_name\>"; then
		echo "installing $package_name..."
		sleep .5
		sudo apt-get install "$package_name" -y
		echo "$package_name installed"
	else
		echo "$package_name already installed"
	fi
done

# remove default firefox
sudo apt purge firefox -y

# upgrade packages
sudo apt clean -y
sudo apt update -y
sudo apt install -f
sudo dpkg --configure -a
sudo apt full-upgrade -y
sudo apt autoremove --purge -y

# ---------------------------------------------------
# Flatpack packages installation
# ---------------------------------------------------
FLATPAK_LIST=(
	org.mozilla.firefox
	com.vscodium.codium
)

# add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for flatpak_name in ${FLATPAK_LIST[@]}; do
	if ! flatpak list | grep -q $flatpak_name; then
		flatpak install "$flatpak_name" -y
	else
		echo "$package_name already installed"
	fi
done

# ---------------------------------------------------
# Custom actions
# ---------------------------------------------------
# setup xanmod for better kernel scheduler experience
echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update -y && sudo apt install linux-xanmod -y

# Update font cache (required after installing MS fonts)
sudo fc-cache -f

# gnome settings
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
# All gedit related settings can be listed with: gsettings list-recursively | grep -i gedit
# Display line numbers in gedit
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
# Tab size is 4 spaces
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor insert-spaces true

# grab mullvad
cd && wget --content-disposition https://mullvad.net/download/app/deb/latest && sudo dpkg -i Mullvad*.deb

# open github to remind me to set up github
firefox https://github.com

echo "➜ Rebooting system"
#confirmation_prompt "Do you want to reboot now?"
#reboot
