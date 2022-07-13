#!/bin/bash

helm repo add minio https://charts.min.io/ --force-update

helm upgrade --install \
  minio minio/minio \
  --namespace builder-demo \
  --create-namespace \
  --set mode=standalone,replicas=1,resources.requests.memory=1Gi,persistence.enabled=false \
  --set rootUser=ROOT_USER,rootPassword=ROOT_USER_PASS_XYZ_123 \
  --set buckets[0].name=cache-bucket-1,buckets[0].policy=none,buckets[0].purge=false \
  --set users[0].accessKey=cache-user-1,users[0].secretKey=CACHE_USER_PASS_XYZ_123,users[0].policy=readwrite \
  --wait