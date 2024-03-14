# base image
FROM ubuntu:20.04

# input GitHub runner version argument
ARG RUNNER_VERSION=2.312.0
ENV DEBIAN_FRONTEND=noninteractive

LABEL BaseImage="ubuntu:20.04"
LABEL RunnerVersion="${RUNNER_VERSION}"

# Substitua YOUR_DOCKER_GID pelo GID que você encontrou no host
ARG DOCKER_GID=999

# Cria um grupo `docker` dentro do contaiiner com o mesmo GID
RUN groupadd -g ${DOCKER_GID} docker

# Adiciona o usuário `docker` ao grupo `docker`
RUN useradd -m -g docker docker

# update the base packages + add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y

# install the packages and dependencies
RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git azure-cli jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common

# Add Docker's official GPG key & install Docker CLI for amd64 architecture
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# cd into the user directory, download and unzip the github actions runner
# check de versions on github runner releases page to change the version
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# add over the start.sh script
ADD ./start.sh /home/docker/start.sh

# make the script executable
RUN chmod +x /home/docker/start.sh

USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["/home/docker/start.sh"]
