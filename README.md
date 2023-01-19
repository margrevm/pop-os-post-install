# Pop!_OS post-installation script

Basic Pop!_OS post-installation shell script for personal use. Feel free to fork and tailor it according to your own needs. I put an emphasis on **(re-)usability** and **simplicity**: No fancy loops, unnecessary code or yes/no prompts... just plain linux commands that are easy to understand and to modify.

## Features

- 📂 Folder structure creation
- 📦 Supports flatpak, snap, .deb and apt package installation
- 🗑️ Cleaning of unnecessary packages and files
- 📥 Cloning of git repositories
- 🔧 Custom actions

## Running the script

The first thing I do on a clean Pop!_OS installation.

```sh
wget https://github.com/margrevm/pop-os-post-install/blob/v22.04/pop-postinstall.sh
sh pop-postinstall.sh

# Alternatively
chmod +x pop-postinstall.sh
./pop-postinstall.sh
```

## Credits

This script is inspired by the work of @al12gamer's [popos-postinstall](https://github.com/al12gamer/popos-postinstall) and @darrow12's [Pop_OS-posInstall](https://github.com/darrow12/Pop_OS-posInstall) scripts.

By Mike Margreve (mike.margreve@outlook.com) and licensed under MIT. The original source can be found here: https://github.com/margrevm/pop-os-post-install
