#!/bin/bash

helm repo add jetstack https://charts.jetstack.io --force-update 

helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true \
  --set global.leaderElection.namespace=cert-manager \
  --set extraArgs='{--enable-certificate-owner-ref=true,--controllers="*\,-certificaterequests-approver" }' \
  --wait

  #--set extraArgs={} \
  #--set webhook.securePort="30001" \
  #--set webhook.hostNetwork=true \


helm upgrade --install \
  cert-manager-csi-driver jetstack/cert-manager-csi-driver \
  --namespace cert-manager \
  --wait


helm upgrade --install \
  cert-manager-approver-policy jetstack/cert-manager-approver-policy \
  --namespace cert-manager \
  --wait