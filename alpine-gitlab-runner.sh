#!/bin/sh
apk update
apk upgrade
apk add openjdk17-jdk git bash gitlab-runner openssh-client

# Comma separated
if [ -z $RUNNER_TAG_LIST ]; then RUNNER_TAG_LIST=""; fi
if [ -z $REGISTRATION_TOKEN ]; then 
    echo "REGISTRATION_TOKEN must be provided"
    exit 1
fi

# Note :
# gitlab-runner uses env variable for parameters configuration.
# REGISTRATION_TOKEN is already used even without --registration-token.
gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.orandja.fr/" \
  --registration-token $REGISTRATION_TOKEN \
  --executor "shell" \
  --tag-list $RUNNER_TAG_LIST \
  --run-untagged="true"

chown -R gitlab-runner:gitlab-runner /etc/gitlab-runner/

rc-service gitlab-runner start
rc-update add gitlab-runner

# generate ssh key and use it for connecting to servers in scripts
ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""
mkdir /var/lib/gitlab-runner/.ssh/
cp .ssh/id_* /var/lib/gitlab-runner/.ssh/

# add server to known host 
ssh-keyscan -H 10.3.0.110 >> /var/lib/gitlab-runner/.ssh/known_hosts

chown -R gitlab-runner:gitlab-runner /var/lib/gitlab-runner/.ssh