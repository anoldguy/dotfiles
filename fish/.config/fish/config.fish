set -q XDG_CONFIG_HOME; or set -Ux XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -Ux XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME; or set -Ux XDG_CACHE_HOME $HOME/.cache
for xdgdir in $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME
    test -d $xdgdir; or mkdir -p $xdgdir
end

# Run 'brew shellenv | source' in reverse order.
for brewcmd in (path filter /usr/local/bin/brew /opt/homebrew/bin/brew $HOME/brew/bin/brew)
    $brewcmd shellenv | source
end
set -q HOMEBREW_PREFIX; or return 1

# Add homebrew completions
if test -e $HOMEBREW_PREFIX/share/fish/completions
    set -a fish_complete_path $HOMEBREW_PREFIX/share/fish/completions
end

# Set editor variables.
set -gx PAGER less
set -gx VISUAL code
set -gx EDITOR vim

# Allow subdirs for functions and completions.
set fish_function_path (path resolve $__fish_config_dir/functions/*/) $fish_function_path
set fish_complete_path (path resolve $__fish_config_dir/completions/*/) $fish_complete_path

set fish_greeting

# Add bits to path; once.
for file_path in /usr/local/sbin $HOME/bin $HOME/go/bin /opt/homebrew/bin $HOME/.cargo/bin
    fish_add_path $file_path
end

# Add my bin directory to path.
fish_add_path --prepend $HOME/bin

# Source private data like credentials or work-related stuff
if test -e $HOME/.private.config.fish
    source $HOME/.private.config.fish
end

# Initialize starship.
starship init fish | source

fish_ssh_agent
