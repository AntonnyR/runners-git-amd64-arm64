#!/bin/bash
#CHANGE THIS
GH_OWNER={CHANGE_THIS}
GH_REPOSITORY=$GH_REPOSITORY
GH_TOKEN={CHANGE_THIS}

RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 5 | head -n 1)
RUNNER_NAME="dockerNode-${RUNNER_SUFFIX}"

cd /home/docker/actions-runner

./config.sh --unattended --url https://github.com/${GH_OWNER} --token ${GH_TOKEN} --name ${RUNNER_NAME}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!