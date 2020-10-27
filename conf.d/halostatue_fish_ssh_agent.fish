function __saplugin__start_agent
    # Don't do ANYTHING if there's already an agent running.
    test -z $SSH_AUTH_SOCK; or return
    # Stop if there's no file.
    test -z $__saplugin_ssh_env; and return

    set -l agent_info (/usr/bin/env ssh-agent | string split \;)

    for line in $agent_info
        if string match -q -r 'SSH_AUTH_SOCK='
            set -x SSH_AUTH_SOCK (string replace -r 'SSH_AUTH_SOCK=(.*);?' '$1' $line)
        else if string match -q -r 'SSH_AGENT_PID='
            set -x SSH_AGENT_PID (string replace -r 'SSH_AGENT_PID=(\d+)' '$1')
        end
    end
end

function __saplugin__add_identities
    test -z $SSH_AUTH_SOCK; and __saplugin__start_agent

    set -l identities

    # Eliminate identities that aren't present.
    for identity in (string replace .pub '' $HOME/.ssh/*.pub)
        test -f $identity; or continue
        set -a identities $identity
    end

    for existing in (ssh-add -L | cut -f3 -d' ' | string match -r '^.+$')
        if set -l i (contains -i -- $existing $identities)
            set -e identities[$i]
        end
    end

    if test (count $identities) -gt 0
        /usr/bin/env ssh-add $identities
    end
end

if is:mac; and test -z $SSH_AUTH_SOCK
    set -l sockets (lsof -c ssh-agent | awk '/unix/ { print $NR; }')
    test (count $sockets) -gt 0; and set -x SSH_AUTH_SOCK $sockets[1]
end

test -L $SSH_AUTH_SOCK
and ln -sf $SSH_AUTH_SOCK /tmp/ssh-agent-{$USER}-screen

__saplugin__start_agent
__saplugin__add_identities

functions -e __saplugin__start_agent __saplugin__add_identities
