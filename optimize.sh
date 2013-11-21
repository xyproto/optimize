#!/bin/bash

# Set the swappiness to 1 so that the swap disk is only used
# when out of memory or rarely in the background.
function set_swappiness() {
  filename=/etc/sysctl.d/99-sysctl.conf
  [[ -f $filename ]] || touch "$filename"
  grep 'vm.swappiness' "$filename" \
    && setconf "$filename" vm.swappiness=1 \
    || echo 'vm.swappiness=1' >> "$filename"
  grep 'vm.vfs_cache_pressure' "$filename" \
    && setconf "$filename" vm.vfs_cache_pressure=50 \
    || echo 'vm.vfs_cache_pressure=50' >> "$filename"
}

# First argument is the yes/no question.
# Second argument is the name of the function to call if "yes".
function ask() {
  while true; do
    read -p "$1 [Yn]" answer
    case $answer in
     [yY]* ) eval "$2"
             break;;
     [nN]* ) echo 'Ok, doing nothing.'
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
  ask 'Set swappiness to 1?' 'set_swappiness'
  echo 'Optimized!'
}

main
