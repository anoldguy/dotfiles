function __ssh_agent_is_started -d "check if ssh agent is already started"
    if begin
            test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"
        end
        source $SSH_ENV >/dev/null
    end

    if test -z "$SSH_AGENT_PID"
        return 1
    end

    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
    return $status
end


function __ssh_agent_start -d "start a new ssh agent"
    ssh-agent -c | grep -v echo >$SSH_ENV
    chmod 600 $SSH_ENV
    source $SSH_ENV >/dev/null
    if is_mac
        ssh-add --apple-use-keychain --apple-load-keychain -q >/dev/null 2>&1 # Ensure we add keys when we start an agent
    else
        ssh-add -q
    end
    true # suppress errors from setenv, i.e. set -gx
end


function fish_ssh_agent --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
    if test -z "$SSH_ENV"
        set -xg SSH_ENV $HOME/.ssh/environment
    end

    if not __ssh_agent_is_started
        __ssh_agent_start
    end
end
