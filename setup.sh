#!/usr/bin/env bash

set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

READLINK=$( type -p greadlink readlink | head -1 || true)
[ -n "$READLINK" ] || abort "cannot find readlink - are you missing GNU coreutils?"

resolve_link() {
  "$READLINK" "$1"
}

abs_dirname() {
  local cwd="$PWD"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

is_linux() {
  if [ $(uname -s) == "Linux" ]; then
    return 0
  else
    return 1
  fi
}

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

check_dependencies(){
 which stow > /dev/null || (echo "GNU Stow required; install via brew or apt" && exit)
 which starship > /dev/null || echo "Starship suggested; install via brew or apt"
 which fish > /dev/null || echo "fish suggested; install via brew or apt"
}

install_prerequisites(){

  DOTFILES_DIR=$(abs_dirname .)
  CLOUD_DIR=$(abs_dirname ..)

  if ! is_linux; then
    # Brew detection and installation
    if test ! $(which brew); then
      echo "⚒ Installing homebrew"
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Set permissions right for $(brew --prefix)/*
    #echo "⚒ Fixing permissions for $(brew --prefix)/*"
    #sudo chown -R $(whoami) $(brew --prefix)/*

    # Install fish first, and ensure the vendor directories exist.
    if test ! $(which fish); then
      echo "⚒ Installing Fish"
      brew install fish pkg-config
    fi
  fi

  if [ ! -d $(pkg-config --variable functionsdir fish) ]; then
    sudo mkdir -p $(pkg-config --variable functionsdir fish)
  fi
  if [ ! -d $(pkg-config --variable completionsdir fish) ]; then
    sudo mkdir -p $(pkg-config --variable completionsdir fish)
  fi

  if ! is_linux; then
    echo "⚒ Installing software from Brewfile"
    brew tap Homebrew/bundle
    brew bundle --force || true
  fi

  echo "🐟 Setting fish as shell"
  shell="$(which fish)"

  if test ! $(grep $shell /etc/shells); then
    which fish | sudo tee -a /etc/shells
  fi

  if [[ ! $SHELL = $shell ]]; then
    chsh -s $shell
  fi

  if [ -d ~/.ssh ]; then
    set +e
    set -x
    ln -s $CLOUD_DIR/.ssh/config ~/.ssh/config
    ssh-add --apple-use-keychain ~/.ssh/basecamp_id_rsa_20160406
  fi
}

check_dependencies
parse_params "$@"
setup_colors

if [ "$cleanup" != "-D" ]; then
  install_prerequisites
fi

for dir in ./*/; do
  package=$(basename "$dir")

  if [ "$cleanup" != "" ]; then
    msg "Cleaning up ${CYAN}$package${NOCOLOR}"
    stow $force $cleanup -t ~ $verbose $package
  else
    msg "Setting up ${CYAN}$package${NOCOLOR}"
    stow $force -t ~ $verbose $package
  fi
done
