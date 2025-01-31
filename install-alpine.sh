#!/bin/bash

shopt -s extglob

SCR_NAME_EXEC=$0
SCR_NAME=$(basename "$SCR_NAME_EXEC")
SCR_NAME=${SCR_NAME%.*}
YSD_DIR=$HOME/scrape-youtube-termux

COLOR_OFF='\033[0m'
COLOR_RED='\033[1;31m'

log() {
  echo -e "[$SCR_NAME] $1"
}

error() {
  log "$1"
  exit "${3:-1}"
}

set_alias() {
  echo "alias container='./container.sh'" >> ../usr/etc/bash.bashrc
}

preflight() {
  setup_storage() {
    [[ ! -d "$HOME"/storage ]] && {
      log "You will now get a permission dialog to allow access to storage."
      sleep 5
      termux-setup-storage
    } || {
      log "Already gotten storage access."
    }
  }

  install_dependencies() {
    [[ -d "$YSD_DIR" ]] && {
      return
    }
    log "Updating Termux and installing dependencies..."
    pkg update -y
    pkg install proot-distro -y || {
      error "$COLOR_RED
Failed to install dependencies.
Possible reasons (in the order of commonality):
1. Termux was downloaded from Play Store. Termux in Play Store is deprecated, and has packaging bugs. Please install it from F-Droid.
2. Mirrors are down at the moment. Try running \`termux-change-repo\`.
3. Internet connection is unstable.
4. Lack of free storage.$COLOR_OFF" n 2
    }
    proot-distro install alpine
  }

  setup_storage
  install_dependencies

  log "Alpine Linux will run, type: sh pot.sh"
  proot-distro login alpine --termux-home
}

main() {
  set_alias
  preflight
}

main $@
