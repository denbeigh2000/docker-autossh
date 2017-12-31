# docker-autossh
> Yet another containerisation of autossh that purportedly doesn't suck.

## Why another containerisation of autossh?
> Don't you have better things to do?

I use autossh, like a lot, and I had some issues with existing implementations.

These are the key takeaways of this container:
 - You can forward multiple ports in one ssh login.
 - You can forward local ports as well as reverse-tunnel remote ports.
 - You can provide your own `ssh_config`, 
 - You are NOT provided `StrictHostKeyChecking=no` as a default, unremovable parameter. **Yikes.**
 - You can specify whatever arbitrary SSH options you want, and it is super easy to do so.
 - You can use consistent, sensible environment variables to set common options.

## Quickstart
```
docker run -p \
    -e SSH_USER='coolguy' \
    -e SSH_HOSTNAME='ssh.example.com' \
    -e SSH_REMOTE_FORWARDS='8080:localhost:8080,3000:localhost:3000' \
    --net=host \
    -v /path/to/id_rsa:/id_rsa \
    -v /path/to/ssh_config:/ssh_config \
    -v /path/to/known_hosts:/known_hosts \
    denbeigh2000/autossh
```

## All Options
| **ENV**                       | Detail                                                                            |
| ----------------------------- | --------------------------------------------------------------------------------- |
| SSH_USER                      | Username used to login (default `root`)                                           |
| SSH_HOSTNAME                  | Hostname of remote host (default `localhost`)                                     |
| SSH_REMOTE_FORWARDS           | Remote forwards as provided to `ssh -R`, comma-separated.                         |
| SSH_LOCAL_FORWARDS            | Local forwards as provided to `ssh -L`, comma-separated.                          |
| SSH_EXTENDED_OPTS             | Extra options as provided to `ssh -o`, comma-separated.                           |
| SSH_CONFIG_FILE               | Path to `ssh_config` (default `/ssh_config`)                                      |
| SSH_IDENTITY_FILE             | Path to private key (typically `~/.ssh/id_rsa`) (default `/id_rsa`)               |
| SSH_KNOWN_HOSTS_FILE          | Path to `known_hosts` (default `/known_hosts`)                                    |
| SSH_STRICT_HOST_KEY_CHECKING  | Set strict host key checking. Provide "yes"/"no", (default deferred to `ssh`)     |

In addition to these, you can also override the sensible defaults provided for
`AUTOSSH_*` env variables, as documented in the `Envionment` section in the
[man page](https://linux.die.net/man/1/autossh).
