def mojave?
  `sw_vers`.match /\s10\.14/
end

tap "basecamp/private", "git@github.com:basecamp/homebrew-private.git"

cask_args appdir: "/Applications"

# FISH!
brew "fish"

# Core utils
brew "coreutils"
brew "git"
brew "gnupg"
brew "pinentry-mac"
brew "awscli"
brew "jq"
brew "curl"
brew "wget"
brew "httpie"
brew "readline"

# Work stuff
brew "37"
brew "work"
brew "mysql", restart_service: :changed
brew "redis", restart_service: :changed

# Language stuff
brew "rbenv"
brew "rbenv-default-gems"
brew "ruby-build"
brew "ant"
brew "go"
brew "typescript"
brew "python"
brew "node"
brew "yarn"

# Shell utilities
brew "prettyping"
brew "bat"
brew "diff-so-fancy"
brew "hub"
brew "jsonpp"
brew "ripgrep"
brew "tldr"
brew "tree"
brew "starship"

# Personal Stuff
brew "wireguard-tools"
brew "yt-dlp"
brew "flac"
brew "libdvdread"
brew "mkvtoolnix"
brew "ffmpeg"

# MacOS Apps
cask "1password-cli"
cask "visual-studio-code"
cask "sketch"
cask "makemkv"
cask "firefox"
cask "gifox"
cask "rectangle"
cask "github"
cask "signal"
cask "yacreader"
cask "xld"
cask "rocket"

# Fonts
tap "homebrew/cask-fonts"

cask "font-mononoki-nerd-font"
