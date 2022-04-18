#!/usr/bin/env bash

# Get current user UID
USER_ID=$(id -u)
# Get current user main GID
GROUP_ID=$(id -g)

prepare_docker_timezone() {
  # https://www.waysquare.com/how-to-change-docker-timezone/
  ENV_VARS+=" --env=TZ=$(cat /etc/timezone)"
}

prepare_docker_user_and_group() {
  RUNNER+=" --user=${USER_ID}:${GROUP_ID}"
}

prepare_docker_from_docker() {
    MOUNTS+=" --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker-host.sock"
}

prepare_docker_ipc_host_sharing() {
  # Allow shared memory to avoid RAM access failures and rendering glitches due to X extesnion MIT-SHM
  EXTRA+=" --ipc=host"
}

prepare_docker_x11_host_sharing() {
   # X11 Unix-domain socket
  MOUNTS+=" --mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix"
  ENV_VARS+=" --env=DISPLAY=unix${DISPLAY}"
  # Credentials in cookies used by xauth for authentication of X sessions
  MOUNTS+=" --mount type=bind,source=${XAUTHORITY},target=${XAUTHORITY}"
  ENV_VARS+=" --env=XAUTHORITY=${XAUTHORITY}"
}

prepare_docker_timezone
prepare_docker_user_and_group
prepare_docker_from_docker
prepare_docker_ipc_host_sharing
prepare_docker_x11_host_sharing

docker run --rm -it \
  --name "ubuntu-tini-dev-chrome-kdiff3" \
  ${ENV_VARS} \
  ${MOUNTS} \
  ${EXTRA} \
  ${RUNNER} \
  rubensa/ubuntu-tini-dev-chrome-kdiff3 "$@"