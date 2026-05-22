#!/bin/bash

IMAGE_NAME=pi-agent
CONTAINER_NAME="pi-agent-$(basename "$(pwd)")"
USER_NAME=node

ACTION="${1:-attach}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(pwd)"
ENV_FILE="$HOME/.pi/.env"



# Check if image exists, build via upgrade if not
ensure_image() {
    if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
        echo "Image '$IMAGE_NAME' not found. Building it first..."
        "$0" upgrade
    fi
}

if [ ! -f "$ENV_FILE" ]; then
    touch "$ENV_FILE"
    echo "Created empty .env file at $ENV_FILE"
else
    echo ".env file already exists at $ENV_FILE"
fi

case "$ACTION" in
    start)
        ensure_image

        # if you want to mount rootless docker.sock, add
#        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        docker run --rm -d \
            --net host \
            --env-file "$ENV_FILE" \
            -v "$REPO_DIR":"$REPO_DIR" \
            -v ~/.pi/agent:/home/$USER_NAME/.pi/agent \
            -w "$REPO_DIR" \
            --name "$CONTAINER_NAME" \
            "$IMAGE_NAME"
        ;;

    attach)
        if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
            echo "Container not running. Starting it first..."
            "$0" start
        fi
        echo "Executing Container ..."
        echo "To detach from container, use: Ctrl-p + Ctrl-q"
        docker exec -it "$CONTAINER_NAME" bash
        ;;

    upgrade)
        docker stop "$CONTAINER_NAME" 2>/dev/null
        docker rm "$CONTAINER_NAME" 2>/dev/null
        docker build --pull --no-cache -t "$IMAGE_NAME" "$SCRIPT_DIR"
        ;;

    stop)
        docker stop "$CONTAINER_NAME" 2>/dev/null
        docker rm "$CONTAINER_NAME" 2>/dev/null
        ;;

    *)
        echo "Usage: $0 {start|attach|stop|upgrade}"
        exit 1
        ;;
esac