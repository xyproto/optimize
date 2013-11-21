#!/bin/bash

function set_swappiness() {
  filename=/etc/sysctl.d/99-sysctl.conf
  if [[ ! -f $filename ]]; then
    touch "$filename"
  fi
  setconf -a "$filename" vm.swappiness 1
  setconf -a "$filename" vm.vfs_cache_pressure 50
}

# first argument is the yes/no question
# second argument is the name of the function to call if yes
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

function root() {
  if [[ $UID != 0 ]]; then
    echo 'Run with sudo or as root'
    exit 1
  fi
}

function main() {
  root
  ask 'Set swappiness to 1?' 'set_swappiness'
  echo 'Optimized!'
}

main
