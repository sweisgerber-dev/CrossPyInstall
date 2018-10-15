#!/usr/bin/env bash
HOSTNAME="CrossPyInstall"
HOST_PATH_1="/PATH/TO/PYTHON_CODE/PROJECT_01"
DOCKER_PATH_1="/aosp/project_01"

docker run -ti \
    --hostname ${HOSTNAME} \
    --volume ${HOST_PATH_1}:${DOCKER_PATH_1} \
    -e LOCAL_USER_ID=`id -u $USER` \
    -e LOCAL_GROUP_ID=`id -g $USER` \
    crosspyinstall:latest
