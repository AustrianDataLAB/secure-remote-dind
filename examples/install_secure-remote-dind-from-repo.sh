#!/bin/bash

helm repo add secure-remote-dind https://austriandatalab.github.io/secure-remote-dind --force-update

helm upgrade --install  \
  builder-demo secure-remote-dind/secure-remote-dind \
  --namespace builder-demo \
  --create-namespace \
  --wait
