#!/bin/sh
apk update
apk upgrade
apk add openjdk17-jdk git bash gitlab-runner

if [ -z $RUNNER_TAGS ]; then RUNNER_TAGS=""; fi
if [ -z $PROJECT_REGISTRATION_TOKEN ]; then 
    echo "PROJECT_REGISTRATION_TOKEN must be provided"
    exit 1
fi

gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.orandja.fr/" \
  --registration-token "$PROJECT_REGISTRATION_TOKEN" \
  --executor "shell" \
  --tag-list "$RUNNER_TAGS" \
  --run-untagged="true"

chown -R gitlab-runner:gitlab-runner /etc/gitlab-runner/

rc-service gitlab-runner start
rc-update add gitlab-runner