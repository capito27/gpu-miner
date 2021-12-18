#!/bin/bash

set -eu


echo "Installing build-essential, python3-pip and nvidia-cuda-toolkit"
sudo apt install -y build-essential nvidia-cuda-toolkit

# Dealing with cmake
# If cmake is old or missing, add kitware repos and grab the latest
# From https://stackoverflow.com/a/4024263
verlte() {
    [  "$1" = "`echo -e "$1\n$2"  | sort -V | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

# Require at least CMAKE 3.20
MININMAL_CMAKE_VER="3.20"
CURRENT_CMAKE_VER="$( (cmake --version 2>/dev/null  | cut -d" " -f3 | head -n 1 ))"
# If CMake is already installed, and older than the minimal version, uninstall it first
if [ -n "$CURRENT_CMAKE_VER" ] && verlt "$CURRENT_CMAKE_VER" "$MININMAL_CMAKE_VER" ;then
  echo "removing outdated cmake version"
  sudo apt purge --auto-remove cmake
fi

# If no CMake is installed (or was outdated and removed), setup kitware's repo, and install recent CMake
if ! command -v cmake &> /dev/null ; then
  echo "Installing latest cmake..."
  sudo apt update && \
  sudo apt install -y software-properties-common lsb-release && \
  sudo apt clean all
  wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
  sudo apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
  sudo apt update
  sudo apt install -y kitware-archive-keyring
  sudo rm /etc/apt/trusted.gpg.d/kitware.gpg
  sudo apt update
  sudo apt install -y cmake
fi

echo "Installing conan"
temp_file=$(mktemp --suffix=.deb)
curl -L https://github.com/conan-io/conan/releases/latest/download/conan-ubuntu-64.deb -o $temp_file
sudo apt install $temp_file
rm -f $temp_file