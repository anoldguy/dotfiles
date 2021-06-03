#!/usr/bin/env bash

set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
  cat <<EOF
Usage: $(basename "$0") [-h] [-v] [-f] 

Install prerequisites and configure dotfiles

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --force     Force installation
-c, --cleanup   Uninstall/Cleanup dotfiles
-i, --init      Set shell and install software
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOCOLOR='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOCOLOR='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  force=""
  verbose=""
  cleanup=""
  target="$HOME"
  arch=$(arch)

  while :; do
    case "${1-}" in
    -h | --help)
      usage
      ;;
    -v | --verbose)
      set -x
      verbose="-v"
      ;;
    --no-color)
      NO_COLOR=1
      ;;
    -f | --force)
      force="--restow"
      ;;
    -c | --cleanup)
      cleanup="-D"
      ;;
    -?*)
      die "Unknown option: $1"
      ;;
    *)
      break
      ;;
    esac
    shift
  done

  return 0
}

parse_params "$@"
setup_colors

link_dotfiles(){
  local cleanup="$1"
  
  if [ "$cleanup" != "" ]; then
    verb="Cleaning"
  else
    verb="Setting"
  fi

  # Relies on current directory
  for dir in ./*/; do
    realdir=$(realpath "$dir")
    package=$(basename "$dir")
    
    msg "$verb up ${CYAN}$package${NOCOLOR}"
    stow $force $cleanup -t ~ $verbose $package
  done
}

change_shell(){
  msg "Changing shell to 🐟"
  shell="$(which fish)"

  if test ! $(grep $shell /etc/shells); then
    sudo bash -c "echo $shell >> /etc/shells"
  fi

  if [[ ! $SHELL = $shell ]]; then
    chsh -s $shell
  fi
}

is_arm(){
  [ "$arch" == "arm64" ]
}

is_mac(){
  os=$(uname -s)
  [ "$os" == "Darwin" ]
}

install_software(){
  if [ is_mac ]; then
    msg "Installing brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH=$PATH:$(brew_path)
    [ -e Brewfile ] && brew bundle
  fi
}

brew_path(){
  is_arm && echo "/opt/homebrew/bin" || echo "/usr/local/bin"
}

install_software
#link_dotfiles $cleanup
#change_shell
