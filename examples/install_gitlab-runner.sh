#!/bin/bash

helm repo add gitlab https://charts.gitlab.io --force-update 

DEMO_NAME="builder-demo" envsubst < runner.values.yaml > values.yaml

helm upgrade --install \
  runner gitlab/gitlab-runner \
  --namespace builder \
  --create-namespace \
  --set gitlabUrl: "gitlab.com" \
  --set runnerRegistrationToken: "" \
  --values values.yaml \
  --wait