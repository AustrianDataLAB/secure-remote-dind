#!/bin/bash

helm repo add gitlab https://charts.gitlab.io --force-update 

helm upgrade --install \
  runner gitlab/gitlab-runner \
  --namespace builder \
  --create-namespace \
  --set gitlabUrl: "gitops.wu.ac.at" \
  --set runnerRegistrationToken: "" \
  --values runner.values.yaml \
  --wait