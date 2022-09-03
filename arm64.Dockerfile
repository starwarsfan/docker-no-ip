ARG ALPINE_VERSION="${ALPINE_VERSION:-edge-arm64}"
FROM alpine:"${ALPINE_VERSION}"

COPY qemu-aarch64-static /usr/bin/

LABEL maintainer="https://github.com/starwarsfan"
