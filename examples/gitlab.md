# secureremotedind Helm Chart

A Helm Chart containing:

- [gitlab-runner](https://docs.gitlab.com/runner/executors/kubernetes.html) - as pipeline executor on k8s
- [minio-tenant](https://github.com/minio/operator/tree/master/helm/tenant) - as gitlab pipeline s3 cache
- [dind-rootless](https://docs.docker.com/engine/security/rootless/#best-practices) - as docker build service

## Requirements

- [Minio Operator](https://github.com/minio/operator/tree/master/helm/operator) (already deployed on ADLS k8s)

## How to install

1. add helm repository

- see: [https://docs.gitlab.com/ee/user/packages/helm_repository/#authenticate-to-the-helm-repository](https://docs.gitlab.com/ee/user/packages/helm_repository/#authenticate-to-the-helm-repository)

```sh
helm repo add runner \
  --username YOUR_API_TOKEN_NAME \
  --password YOUR_API_TOKEN \
  https://gitlab.tuwien.ac.at/api/v4/projects/2797/packages/helm/stable

helm repo update
```

2. install with gitlab.runnerRegistrationToken

```sh
helm upgrade --install \
  --namespace MY_RUNNER_NAMESPACE \
  --create-namespace \
  --set runner.registrationToken="MY_RUNNER_TOKEN" \
  --set minio.user.accesskey="A_RANDOM_A_KEY" \
  --set minio.user.secretkey="A_RANDOM_S_KEY" \
  MY_RUNNER_NAME runner/secureremotedind
```

## Minio

```sh
export YOUR_DEPlOYMENT_NAME=""

kubectl port-forward \
  ${YOUR_DEPlOYMENT_NAME}-secureremotedind-minio-console \
  9090:9090
```

```sh
kubectl get secret \
  ${YOUR_DEPlOYMENT_NAME}-secureremotedind-minio-user-secret \
  -o jsonpath="{.data.CONSOLE_ACCESS_KEY}" | base64 --decode
```

```sh
kubectl get secret \
  ${YOUR_DEPlOYMENT_NAME}-secureremotedind-minio-user-secret \
  -o jsonpath="{.data.CONSOLE_SECRET_KEY}" | base64 --decode
```
