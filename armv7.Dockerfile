ARG ALPINE_VERSION="${ALPINE_VERSION:-edge-armv7}"
FROM alpine:"${ALPINE_VERSION}"

COPY qemu-arm-static /usr/bin/

LABEL maintainer="https://github.com/starwarsfan"
