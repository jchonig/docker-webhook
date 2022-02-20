# docker-g10k
A container running [webhook](https://github.com/adnanh/webhook) based
on [linuxserver.io](https://www.linuxserver.io/) s6 overlay based
container.

The purpose is to catch webhook posts from a git server and run g10 to
build puppet environments.

# Usage

## docker

```
docker create \
  --name=webook \
  -e TZ=Europe/London \
  --expose 9000 \
  --restart unless-stopped \
  jchonig/webhook
```

### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "3"
services:
  monit:
    image: jchonig/webhook
    container_name: webhook
    environment:
      TZ: Europe/London
	  HOOK_ARGS: "-hooks /config/hooks.json -hotreload"
    volumes:
      - </path/to/appdata/config>:/config
    expose:
      - 9000
    restart: unless-stopped
```

# Parameters

## Ports (--expose)

| Volume | Function    |
| ------ | --------    |
| 9000   | Webook port |

## Environment Variables (-e)

| Env          | Function                                |
|--------------|-----------------------------------------|
| PUID=1000    | for UserID - see below for explanation  |
| PGID=1000    | for GroupID - see below for explanation |
| TZ=UTC       | Specify a timezone to use EG UTC        |
| HOOK_ARGS    | Arguments to the webhook command        |
| HOOK_SECRET  | Webhook secret                          |
| HOOK_COMMAND | Command to run when using a git webhook |

## Volume Mappings (-v)

| Volume               | Function                                 |
| ------               | --------                                 |
| /config              | All the config files reside here         |

# Application Setup

  * Environment variables can also be passed in a file named `env` in
    the `config` directory. This file is sourced by the shell.
  * To use a git webhook:
    * Set `HOOK_SECRET` to the shared secret.
	* Set `HOOK_COMMAND` to the command to run when a webhook is received.
    * Set `HOOK_ARGS` to `-template -hooks /etc/webhook/githook.yaml.tmpl`.
	* The webhook will run in the /config directory.  If other files
      are needed (such as a `.ssh` directory) put it there.
