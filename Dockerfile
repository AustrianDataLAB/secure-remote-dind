FROM docker:rc-dind-rootless

USER root

RUN apk add slirp4netns

USER rootless