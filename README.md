# Docker image with development tools and kdiff3

This is a Docker image based on [rubensa/ubuntu-tini-dev-chrome](https://github.com/rubensa/docker-ubuntu-tini-dev-chrome) with kdiff3 for development.

## Building

You can build the image like this:

```
#!/usr/bin/env bash

docker build --no-cache \
  -t "rubensa/ubuntu-tini-dev-chrome-kdiff3" \
  --label "maintainer=Ruben Suarez <rubensa@gmail.com>" \
  .
```

## Running

You can run the container like this (change --rm with -d if you don't want the container to be removed on stop):

```
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
```

*NOTE*: Mounting /var/run/docker.sock allows host docker usage inside the container (docker-from-docker).

This way, the internal user UID an group GID are changed to the current host user:group launching the container and the existing files under his internal HOME directory that where owned by user and group are also updated to belong to the new UID:GID.

## Connect

You can connect to the running container like this:

```
#!/usr/bin/env bash

docker exec -it \
  ubuntu-tini-dev-chrome-kdiff3 \
  bash -l
```

This creates a bash shell run by the internal user.

Once connected...

You can check installed develpment software:

```
gcc --version
g++ --version
make --version
git version
git lfs install --skip-repo
conda info
sdk version
nvm --version
google-chrome-stable --headless --disable-gpu --no-sandbox --dump-dom http://www.chromestatus.com
kdiff3
```

## Stop

You can stop the running container like this:

```
#!/usr/bin/env bash

docker stop \
  ubuntu-tini-dev-chrome-kdiff3
```

## Start

If you run the container without --rm you can start it again like this:

```
#!/usr/bin/env bash

docker start \
  ubuntu-tini-dev-chrome-kdiff3
```

## Remove

If you run the container without --rm you can remove once stopped like this:

```
#!/usr/bin/env bash

docker rm \
  ubuntu-tini-dev-chrome-kdiff3
```
