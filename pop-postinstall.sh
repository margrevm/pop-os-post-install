#!/usr/bin/env bash

#  ____             _     ___  ____  
# |  _ \ ___  _ __ | |   / _ \/ ___| 
# | |_) / _ \| '_ \| |  | | | \___ \ 
# |  __/ (_) | |_) |_|  | |_| |___) |
# |_|   \___/| .__/(_)___\___/|____/ 
#            |_|    |_____|
#
# Post-installation script for Pop!_OS

function prompt_y_n() {
    read -p "$1 (y/n) " yn
    case $yn in 
        [yY] ) ;;
        [nN] ) echo exiting...;
            exit;;
        * ) echo invalid response;;
    esac
}

# 
prompt_y_n "Do you want to run the script now?"

# ---------------------------------------------------
# Creating folder structure
# ---------------------------------------------------
echo "[Creating the folder structure]"
# Folder for projects (other than source code)
mkdir -pv $HOME/projects
# Folder for bash 'general use' scripts
mkdir -pv $HOME/scripts
# Folder for source code and repos
mkdir -pv $HOME/src
# Folder for downloaded packages
DL_DIR=$HOME/Downloads/packages
mkdir -pv $DL_DIR

# ---------------------------------------------------
# APT package installation
# ---------------------------------------------------
echo "[Installing apt packages]"

APT_INSTALL_PACKAGES=(
	tree
	neofetch
	snapd
	vlc
	htop
	gnome-tweaks
	python3
	python3-distutils
	nmap
	wget
	java-latest-openjdk
	heif-gdk-pixbuf
	codium
	git
	curl
	unzip
	xclip
	less
	ttf-mscorefonts-installer
)

# Danger zone /!\ Please be careful and make sure to not purge/remove any essential packages
APT_PURGE_PACKAGES=(
	geary
	gnome-contacts
)

APT_REMOVE_PACKAGES=(
)

echo "➜ Adding apt repositories..."
# Repo for VSCodium which is VSCode whitout Miccrosoft telemetry. More infos on https://vscodium.com/.
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg 
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list 

echo "➜ Updating apt repositories..."
sudo apt update -y

echo "➜ Installing packages..."
# Existing packages will not be installed by apt.
sudo apt install $APT_INSTALL_PACKAGES -y

echo "➜ Purging/removing apt packages..."
# This will remove the package and the configuration files (/etc)
# Should be used for applications you will never need. If you are not sure use 'apt remove' 
# instead (uncomment below) which will leave the config files.
sudo apt purge $APT_PURGE_PACKAGES -y
#sudo apt remove $APT_REMOVE_PACKAGES -y

echo "➜ Removing unused apt package dependencies..."
# ... packages that are not longer needed
sudo apt autoremove

echo "➜ Upgrading apt packages to their latest version..."
# 'apt full-upgrade' is an enhanced version of the 'apt upgrade' command. 
# Apart from upgrading existing software packages, it installs and removes 
# some packages to satisfy some dependencies. The command includes a smart conflict 
# resolution feature that ensures that critical packages are upgraded first 
# at the expense of those considered of a lower priority.
sudo apt full-upgrade -y

echo "➜ Cleaning package cache..."
# 'apt autoclean' removes all stored archives in your cache for packages that can not 
# be downloaded anymore (thus packages that are no longer in the repo or that have a newer version in the repo).
# You can use 'apt clean' to remove all stored archives in your cache to safe even more disk space.
sudo apt autoclean
#sudo apt clean -y

# ---------------------------------------------------
# Flatpack packages installation
# ---------------------------------------------------
echo "[Installing flatpak packages]"

FLATPAK_INSTALL_PACKAGES=(
	spotify
	net.cozic.joplin_desktop
)

echo "➜ Add flatpak repositories..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "➜ Install flatpak packages..."
flatpak install "$FLATPAK_INSTALL_PACKAGES" -y

echo "➜ Udate flatpak packages..."
flatpak update

# ---------------------------------------------------
# Snap packages installation
# ---------------------------------------------------
echo "[Installing snap packages]"
# Important: Install 'snapd' to support snap packages (available as apt package).
# Snap is not natively supported by Pop!_OS. The usage of flatpak is recommended.
SNAP_INSTALL_PACKAGES=(
	bw
)

echo "➜ Install snap packages..."
snap install "$SNAP_INSTALL_PACKAGES" -y

echo "➜ Update snap packages..."
snap update

# ---------------------------------------------------
# .deb packages installation (manual)
# ---------------------------------------------------
#echo "[Downloading and installing .deb packages manually]"

#echo "➜ Downloading .deb packages..."
#wget -c "<URL>" -P "$DL_DIR"

#echo "➜ Installing .deb packages..."
#sudo dpkg -i $DL_DIR/*.deb
#sudo apt install -f

# ---------------------------------------------------
# Other packages (full manual installation)
# ------------------------------------------------
#echo "[Other packages]"


# ---------------------------------------------------
# Custom actions
# ---------------------------------------------------
# setup xanmod for better kernel scheduler experience
echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update -y && sudo apt install linux-xanmod -y

# ------ CapsLock delay fixer ------ #
echo "[📝 Fixing capslock delay]"
echo ""

git clone https://github.com/hexvalid/Linux-CapsLock-Delay-Fixer.git
cd Linux-CapsLock-Delay-Fixer/
mv bootstrap.sh ..
cd ..
bash -ic "sh bootstrap.sh"
rm -r Linux-CapsLock-Delay-Fixer/


# ---------------------------------------------------
# Clone repos
# ---------------------------------------------------


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

# ------ Installation completed ------ #

clear
neofetch
echo "📁 Your archives ⤵"
tree $HOME
echo ""
ls
echo ""
echo "✅ Installation completed!"
echo "Enjoy your new computer! 💻"
echo ""
echo "💬 If you have any questions, please contact me on Discord: Darrow#9826"
echo "And if you have bugs, please make a issue"
echo ""
cowsay Have fun!

echo "➜ Rebooting system"
#prompt_y_n "Do you want to reboot now?"
#reboot
