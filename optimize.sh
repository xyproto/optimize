#!/bin/bash

# Set the swappiness to 1 so that the swap disk is only used
# when out of memory or rarely in the background.
function set_swappiness() {
  fn=/etc/sysctl.d/99-sysctl.conf
  setconf -a "$fn" vm.swappiness=1
  setconf -a "$fn" vm.vfs_cache_pressure=50
}

# Set the dirty_ratio to a more sensible value
function set_dirty_ratio() {
  fn=/etc/sysctl.d/99-sysctl.conf
  setconf -a "$fn" vm.dirty_ratio=3
  setconf -a "$fn" vm.dirty_background_ratio=2
}

# Optimize the pacman database and rank the mirrors, if pacman is installed
function optimize_pacman() {
  [[ -f /etc/pacman.conf ]] && LC_ALL=C pacman-optimize
}

# Rank the various package mirrors by speed
function rank_mirrors() {
  ml=/etc/pacman.d/mirrorlist
  [[ -f $ml ]] || return

  # Copy a suitable mirrorlist file to /tmp, to be used as a basis
  if [[ -f $ml.pacnew ]]; then
    cp -f "$ml.pacnew" /tmp/mirrorlist
  elif [[ -f $ml ]]; then
    cp -f "$ml" /tmp/mirrorlist
  fi
  [[ -f /tmp/mirrorlist ]] || return

  # Generate a new mirrorlist based on the entries in /tmp/mirrorlist
  sed -i 's/#Server/Server/g' /tmp/mirrorlist
  cp -i "$ml" "$ml.backup"
  rankmirrors /tmp/mirrorlist | tee /tmp/new.mirrorlist \
    && cp -f /tmp/new.mirrorlist "$ml"
}

function update_pacman() {
  LC_ALL=C pacman -Sy
}

# First argument is the yes/no question.
# Second argument is the name of the function to call if "yes".
function ask() {
  while true; do
    echo -en "· \e[97m$1\e[0m "
    echo -en '\e[90m[\e[32my\e[93mn\e[31mq\e[90m]\e[36m'
    read answer
    echo -en '\e[0m'
    case $answer in
     [yY]* ) eval "$2"
             break;;
     [nN]* ) echo -e '\e[90mSkipping.\e[0m'
             break;;
     [qQ]* ) echo -e '\e[31mQuitting.\e[0m'
             exit;;
     * ) echo 'Enter y or n.';;
    esac
  done
  echo
}

# Abort if not root
function root() {
  if [[ $UID != 0 ]]; then
    echo -e '\e[31m;Run with sudo or as root.\e[0m;'
    exit 1
  fi
}

function version_info() {
  version_string='\e[34mOptimize \e[94mv0.1'
  echo
  echo -e "\e[90m..--==[ $version_string \e[90m]==--..\e[0m"
  echo
}

function final_message() {
  echo -e '\e[90m[···/ \e[93mSystem Optimized \e[90m\\···]\e[0m\n'
}

# Perform various tweaks
function main() {
  root
  version_info

  # Depends on systemd
  ask 'Set swappiness to 1?' set_swappiness
  ask 'Set dirty_ratio to 3?' set_dirty_ratio

  # Depends on pacman
  if [[ -f /etc/pacman.conf ]]; then
    ask 'Optimize the pacman db?' optimize_pacman
    ask 'Rank pacman mirrors? (takes forever)' rank_mirrors
    ask 'Update pacman now?' update_pacman
  fi

  final_message
}

main
