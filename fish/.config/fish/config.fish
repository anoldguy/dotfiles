set -U fish_greeting "🐟"

# Add bits to path; once.
for file_path in /usr/local/sbin $HOME/bin $HOME/go/bin /opt/homebrew/bin $HOME/.cargo/bin
  fish_add_path $file_path
end

# Source private data like credentials or work-related stuff
if test -e $HOME/.private.config.fish
  source $HOME/.private.config.fish
end

starship init fish | source

# Handle ssh-agent
fish_ssh_agent

if test -e /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
  source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
else if test -e /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
  source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
end
