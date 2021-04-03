function __saplugin__start_agent
    # Don't do ANYTHING if there's already an agent running.
    test -z $SSH_AUTH_SOCK; or return
    # Stop if there's no file.
    test -z $__saplugin_ssh_env; and return

    set -l agent_info (command ssh-agent | string split \;)

    for line in $agent_info
        if string match -q -r 'SSH_AUTH_SOCK=' $line
            set -x SSH_AUTH_SOCK (string replace -r 'SSH_AUTH_SOCK=(.*);?' '$1' $line)
        else if string match -q -r 'SSH_AGENT_PID=' $line
            set -x SSH_AGENT_PID (string replace -r 'SSH_AGENT_PID=(\d+)' '$1' $line)
        end
    end
end

function __saplugin__add_identities
    test -z $SSH_AUTH_SOCK; and __saplugin__start_agent

    set -l identities

    # Eliminate identities that do not have private keys present.
    for identity in (string replace .pub '' $HOME/.ssh/*.pub)
        test -f $identity; or continue
        set -a identities $identity
    end

    for existing in (command ssh-add -L)
        test (count $identities) -eq 0; and break

        set -l body (string split ' ' $existing)[1..2]
        for identity in $identities
            if string match -q -r "^$body" (command cat $identity.pub)
                set -e identities[(contains -i -- $identity $identities)]
                set body
            end

            test -z "$body"; and break
        end

        test -z "$body"; and continue

        set -l name (string split ' ' $existing)[3]
        if set -l i (contains -i -- $name $identities)
            set -e identities[$i]
        end
    end

    if test (count $identities) -gt 0
        command ssh-add $argv $identities
    end
end

set __saplugin__is_mac false

if string match -q -e $type (string lower (uname -s))
    set __saplugin__is_mac true
end


if $__saplugin__is_mac; and test -z $SSH_AUTH_SOCK
    set -l sockets (
        command lsof -c ssh-agent |
        string match -e -r 'unix' |
        string split -r -m 1 -f 2 ' '
    )
    test (count $sockets) -gt 0; and set -x SSH_AUTH_SOCK $sockets[1]
end

test -L $SSH_AUTH_SOCK
and ln -sf $SSH_AUTH_SOCK /tmp/ssh-agent-{$USER}-screen

if set -q $halostatue_fish_ssh_agent_flags
    set __saplugin__flags $halostatue_fish_ssh_agent_flags
else
    if $__saplugin__is_mac
        set __saplugin__flags -q -A -K
    else
        set __saplugin__flags -q
    end
end

__saplugin__start_agent
__saplugin__add_identities $__saplugin__flags

set -e __saplugin__flags __saplugin__is_mac

functions -e __saplugin__start_agent __saplugin__add_identities
