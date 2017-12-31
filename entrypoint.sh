#!/bin/sh

# set a default monitoring port if none provided
# allow the user to specify zero if they *really* want to... for whatever reason
if [ $AUTOSSH_PORT -eq -1 ]
then
    AUTOSSH_PORT=$(( ((RANDOM<<15)|RANDOM) % 63001 + 2000 ))
fi

# handle all remote forwards, comma-separated
if [ ! -z "$SSH_REMOTE_FORWARDS" ]
then
    REMOTE_FORWARDS="-R $(echo "$SSH_REMOTE_FORWARDS" | sed "s/,/ -R /g")"
    SSH_OPTS="${SSH_OPTS} $REMOTE_FORWARDS"
fi

# handle all local forwards, comma-separated
if [ ! -z "$SSH_LOCAL_FORWARDS" ]
then
    LOCAL_FORWARDS="-L $(echo "$SSH_LOCAL_FORWARDS" | sed "s/,/ -L /g")"
    SSH_OPTS="${SSH_OPTS} $LOCAL_FORWARDS"
fi

# handle all ssh_config-style options, comma-separated
if [ ! -z "$SSH_EXTENDED_OPTS" ]
then
    SSH_OPTS="${SSH_OPTS} -o $(echo "$SSH_EXTENDED_OPTS" | sed "s/,/ -o /g")"
fi

# if there is an ssh config file provided, or the default exists, use it
if [ -e "$SSH_CONFIG_FILE" ]
then
    SSH_OPTS="${SSH_OPTS} -F ${SSH_CONFIG_FILE}"
fi

# if we find an id file, ensure it has the right perms, use it
if [ ! -z "$SSH_IDENTITY_FILE" ]
then
    chmod 0400 "$SSH_IDENTITY_FILE"

    SSH_OPTS="${SSH_OPTS} -i ${SSH_IDENTITY_FILE}"
fi

# if there is a known hosts file, use it
if [ -e "$SSH_KNOWN_HOSTS_FILE" ]
then
    SSH_OPTS="${SSH_OPTS} -o UserKnownHostsFile=${SSH_KNOWN_HOSTS_FILE}"
fi

# if the user wants/doesn't want strict host key checking, provide it
if [ ! -z "$SSH_STRICT_HOST_KEY_CHECKING" ]
then
    SSH_OPTS="${SSH_OPTS} -o StrictHostKeyChecking=${SSH_STRICT_HOST_KEY_CHECKING}"
fi

# safety is for the meek - accept arbitrary ssh args
if [ ! -z "$@" ]
then
    SSH_OPTS="${SSH_OPTS} $@"
fi

# Explicitly NOT providing -M to autossh, the AUTOSSH_PORT coes this for us
# (and autossh fails to start if we provide either)
echo "Instantiating autossh with:"
echo autossh \
    -N -t -t \
    -p "$SSH_PORT" \
    $SSH_OPTS $SSH_USER@${SSH_HOSTNAME}

AUTOSSH_PIDFILE=/autossh.pid \
AUTOSSH_LOGFILE=/dev/stdout \
autossh \
    -N -t -t \
    -p "$SSH_PORT" \
    $SSH_OPTS $SSH_USER@${SSH_HOSTNAME}
