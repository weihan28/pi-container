# docker-pi

My config and script to run the coding harness [pi](https://pi.dev/) in a rootless Docker container.

Note: not a complete replacement for proper sandboxing, but as a safeguard.

## Quick start

```bash
git clone https://github.com/foertel/docker-pi-coding-agent.git ~/docker-pi
cd your-project
~/docker-pi/dock.sh <command>
```

## Commands

| Command   | What it does                                                    |
|-----------|-----------------------------------------------------------------|
| `start`   | Start the container in the background                           |
| `attach`  | Attach to a running container (auto starts if it doesn't exist) |
| `stop`    | Stop and remove the container                                   |
| `upgrade` | Rebuild the image and stop the old container                    |

I also add an alias to my `.zshrc` for convenience:
```bash
alias dock="~/docker-pi/dock.sh"
```

I usually `cd` to the repo I want to mount and just run `dock attach`. 

## How it works

- Mounts your current directory into the container
- Mounts `~/.pi/agent` so your config, session history is shared across all containers (selectively mounts to avoid the env file)
- Store any other env variables u want in `~/.pi/.env` 
