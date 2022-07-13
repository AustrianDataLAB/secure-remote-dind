#!/bin/bash

helm upgrade \
  --namespace builder-demo \
  --create-namespace \
  --install builder-demo \
  ../Charts/secure-remote-dind \
  --wait
