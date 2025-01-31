#!/bin/bash

SCR_NAME_EXEC=$0
SCR_NAME=$(basename "$SCR_NAME_EXEC")
SCR_NAME=${SCR_NAME%.*}
YSD_DIR=$HOME/scrape-youtube-termux

log() {
  echo -e "[$SCR_NAME] $1"
}

error() {
  log "$1"
  exit "${3:-1}"
}

dload_and_install() {
  log "Downloading scrape-youtube-termux..."
  curl -sLo scrape-youtube-termux.zip https://github.com/inotia00/scrape-youtube-termux/archive/refs/heads/main.zip
  unzip -qqo scrape-youtube-termux.zip
  rm scrape-youtube-termux.zip
  mv scrape-youtube-termux-main scrape-youtube-termux
  cd scrape-youtube-termux
  log "Installing packages..."
  yarn install --omit=dev
}

preflight() {
  install_dependencies() {
    [[ -d "$YSD_DIR" ]] && {
      return
    }
    apk update
    apk add --no-cache nmap
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
    echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
    apk upgrade
    apk add yarn
    apk add --no-cache chromium
    apk add git
  }

  install_dependencies

  [[ ! -d "$YSD_DIR" ]] && {
    dload_and_install n
  } || {
    log "Launch scrape-youtube-termux.."
    }
}

run_scraper() {
  preflight
  termux-wake-lock
  cd "$YSD_DIR"
  node index.js
  termux-wake-unlock
}

main() {
  run_scraper
}

main $@
