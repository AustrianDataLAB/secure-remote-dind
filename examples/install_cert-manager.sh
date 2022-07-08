#!/bin/bash

helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.0-beta.1 \
  --set installCRDs=true \
  --set global.leaderElection.namespace=cert-manager \
  --wait

  #--set extraArgs={--controllers='*\,-certificaterequests-approver'} \
  #--set webhook.securePort="30001" \
  #--set webhook.hostNetwork=true \

#helm upgrade -i -n cert-manager cert-manager-approver-policy jetstack/cert-manager-approver-policy --wait
helm upgrade -i -n cert-manager cert-manager-csi-driver jetstack/cert-manager-csi-driver --wait