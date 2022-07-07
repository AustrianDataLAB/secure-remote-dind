# Secure Remote Docker-in-Docker

A Helm Chart containing: [dind-rootless](https://docs.docker.com/engine/security/rootless/#best-practices) - as docker build service

## How to access the dind services

### From inside the docker-in-docker deployment

```sh
export pod_name=$(kubectl get pod \
  --selector=app.kubernetes.io/name=secureremotedind \
  --no-headers -o custom-columns=":metadata.name")

kubectl exec -it $pod_name -- docker info
```

### From Localhost

1. Download needed certificates

    ```sh
    mkdir -p `pwd`/certs/ca

    export secret_name=$(kubectl get secret \
      --selector=app.kubernetes.io/name=secureremotedind \
      --no-headers -o custom-columns=":metadata.name")

    #download tls.key
    kubectl get secret ${secret_name} \
      -o jsonpath="{.data.tls\.key}" | base64 --decode \
      > `pwd`/certs/ca/key.pem

    #download ca.crt
    kubectl get secret ${secret_name} \
      -o jsonpath="{.data.ca\.crt}" | base64 --decode \
      > `pwd`/certs/ca/ca.pem

    #ca.crt == tls.crt because it's the root CA
    cp -f `pwd`/certs/ca/ca.pem `pwd`/certs/ca/cert.pem
    ```

2. Forward the tcp port 2376 of the docker-in-docker service

    ```sh
    export service_name=$(kubectl get service \
      --selector=app.kubernetes.io/name=secureremotedind \
      --no-headers -o custom-columns=":metadata.name")

    kubectl port-forward svc/${service_name} 2376:2376
    ```

3. connect to docker

     1. docker cli: [https://docs.docker.com/engine/securityprotect-access/#secure-by-default](https://docs.docker.comengine/security/protect-access/#secure-by-default)

      ```sh
      export DOCKER_HOST=tcp://localhost:2376
      export DOCKER_TLS_VERIFY=1
      export DOCKER_CERT_PATH=`pwd`/certs/ca

      docker info
      ```

    1. curl: [https://docs.docker.com/engine/securityprotect-access#connecting-to-the-secure-docker-port-using-curl](https:/docs.docker.com/engine/security/protect-access#connecting-to-the-secure-docker-port-using-curl)

      ```sh
      curl https://localhost:2376/info \
        --cert `pwd`/certs/ca/cert.pem \
        --key `pwd`/certs/ca/key.pem \
        --cacert `pwd`/certs/ca/ca.pem \
        | jq
      ```
