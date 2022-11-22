FROM docker:dind-rootless

USER root

RUN apk add slirp4netns

USER rootless
