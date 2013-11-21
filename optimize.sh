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
  [[ -f /etc/pacman.conf ]] || return
  LC_ALL=C pacman-optimize
}

# Rank the various package mirrors by speed
function rank_mirrors() {
  ml=/etc/pacman.d/mirrorlist
  [[ -f $ml ]] || return
  if [[ -f $ml.pacnew ]]; then
    cp -f "$ml.pacnew" /tmp/mirrorlist
  elif [[ -f $ml ]]; then
    cp -f "$ml.pacnew" /tmp/mirrorlist
  fi
  if [[ -f /tmp/mirrorlist ]]; then
    sed -i 's/#Server/Server/g' /tmp/mirrorlist
  fi
  cp -i "$ml" "$ml.backup"
  rankmirrors /tmp/mirrorlist | tee /tmp/new.mirrorlist \
    && cp -f /tmp/new.mirrorlist "$ml"
}

# First argument is the yes/no question.
# Second argument is the name of the function to call if "yes".
function ask() {
  while true; do
    read -p "$1 [ynq]" answer
    case $answer in
     [yY]* ) eval "$2"
             break;;
     [nN]* ) echo 'Ok, skipping.'
             break;;
     [qQ]* ) echo 'Quitting.'
             exit;;
     * ) echo 'Enter y or n.';;
    esac
  done
}

# Abort if not root
function root() {
  if [[ $UID != 0 ]]; then
    echo 'Run with sudo or as root'
    exit 1
  fi
}

# Perform various tweaks
function main() {
  root

  # Depends on systemd
  ask 'Set swappiness to 1?' set_swappiness
  ask 'Set dirty_ratio to 3?' set_dirty_ratio

  # Depends on pacman
  if [[ -f /etc/pacman.conf ]]; then
    ask 'Optimize the pacman db?' optimize_pacman
    ask 'Rank pacman mirrors? (takes forever)' rank_mirrors
  fi

  echo 'Optimized!'
}

main
