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
echo "[Creating the folder structure]"
# Folder for projects (other than source code)
mkdir -pv $HOME/projects
# Folder for bash 'general use' scripts
mkdir -pv $HOME/scripts
# Folder for source code and repos
mkdir -pv $HOME/src

# ---------------------------------------------------
# APT package installation
# ---------------------------------------------------
echo "[Installing APT packages]"

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
	git
	curl
)

# Add respositiories
echo "➜ Add repositories"
# Repo for VSCodium which is VSCode whitout Miccrosoft telemetry. More infos on https://vscodium.com/.
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
#sudo apt purge firefox -y

# upgrade packages
sudo apt clean -y
sudo apt autoclean
sudo apt update -y
sudo apt install -f
sudo dpkg --configure -a
sudo apt full-upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove --purge -y

# ---------------------------------------------------
# Flatpack packages installation
# ---------------------------------------------------
#TODO Add Chromium with codecs, ...
FLATPAK_LIST=(
	spotify
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

flatpak update

# ---------------------------------------------------
# Snap packages installation
# ---------------------------------------------------
# Important: Install 'snapd' to support snap packages (available as apt package).
# TODO Add



# ------ Installing softwares ------ #
echo "[📥 Downloading and installing external software]"
echo ""

mkdir "$DOWNLOADS_DIRECTORY"
wget -c "$URL_VIVALDI" -P "$DOWNLOADS_DIRECTORY"
wget -c "$URL_DISCORD" -P "$DOWNLOADS_DIRECTORY"
wget -c "$URL_HYPER_TERMINAL" -P "$DOWNLOADS_DIRECTORY"
wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DOWNLOADS_DIRECTORY"
wget -c "$URL_TICKTICK" -P "$DOWNLOADS_DIRECTORY"
wget -c "$URL_MEGASYNC" -P "$DOWNLOADS_DIRECTORY"
wget -c "$URL_VSCODE" -P "$DOWNLOADS_DIRECTORY"

sudo dpkg -i $DOWNLOADS_DIRECTORY/*.deb
sudo apt install -f

# ------ Installing some packages ------ #
echo "[📦 Installing others packages]"
echo ""

npm i sass -g
npm install -g nativefier
npm install -g nodemon

sudo apt update
sudo apt install -f

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
#confirmation_prompt "Do you want to reboot now?"
#reboot
