# Gate ruby stuff on presence of rbenv
if status --is-interactive; and which rbenv >/dev/null
    source (rbenv init -|psub)

    set --export BUNDLE_PATH ".bundle/gems"
    set --export BUNDLE_BIN ".bundle/bin"
    set --export BUNDLER_EDITOR "code --add"
    set --export UNSPRUNG 1

    for file_path in $HOME/.rbenv/shims $BUNDLE_BIN $HOME/.nodenv/shims
        if not contains $file_path $fish_user_paths
            set -Ua fish_user_paths $file_path
        end
    end
end
