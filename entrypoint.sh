#!/bin/sh

set +ex

ID_RSA="/id_rsa"

touch "$ID_RSA"
chmod 0400 "$ID_RSA"

# set a default monitoring port if none provided
# allow the user to specify zero if they *really* want to... for whatever reason
if [ $AUTOSSH_PORT -eq -1 ]
then
    AUTOSSH_PORT=$(( ((RANDOM<<15)|RANDOM) % 63001 + 2000 ))
fi

if [ ! -z "$SSH_REMOTE_FORWARDS" ]
then
    REMOTE_FORWARDS="-R $(echo "$SSH_REMOTE_FORWARDS" | sed "s/,/ -R /g")"
    SSH_OPTS="${SSH_OPTS} $REMOTE_FORWARDS"
fi

if [ ! -z "$SSH_LOCAL_FORWARDS" ]
then
    LOCAL_FORWARDS="-L $(echo "$SSH_LOCAL_FORWARDS" | sed "s/,/ -L /g")"
    SSH_OPTS="${SSH_OPTS} $LOCAL_FORWARDS"
fi

if [ ! -z "$EXTENDED_SSH_OPTS" ]
then
    SSH_OPTS="${SSH_OPTS} -o $(echo "$EXTENDED_SSH_OPTS" | sed "s/,/ -o /g")"
    echo $SSH_OPTS
fi

# safety is for the meek - accept arbitrary ssh args
if [ ! -z "$@" ]
then
    SSH_OPTS= "${SSH_OPTS} $@"
fi

# Explicitly NOT providing -M to autossh, the AUTOSSH_PORT coes this for us
# (and autossh fails to start if we provide either)

echo "Instantiating autossh with:"
echo AUTOSSH_PIDFILE=/autossh.pid \
AUTOSSH_LOGFILE=/dev/stdout \
autossh \
    -t -t \
    -i "$ID_RSA" \
    $SSH_OPTS $SSH_HOSTUSER@${SSH_HOSTNAME}

AUTOSSH_PIDFILE=/autossh.pid \
AUTOSSH_LOGFILE=/dev/stdout \
autossh \
    -t -t \
    -i "$ID_RSA" \
    -p "$SSH_TARGET_PORT" \
    $SSH_OPTS $SSH_HOSTUSER@${SSH_HOSTNAME}
