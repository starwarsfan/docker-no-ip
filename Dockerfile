FROM alpine:edge as builder
ENV ALPINE_VERSION=edge

LABEL maintainer="https://github.com/starwarsfan"


RUN echo "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories
RUN apk --update upgrade \
 && apk add \
        autoconf \
        bash \
        g++ \
        make \
 && rm -rf /var/cache/apk/*

WORKDIR no-ip

ADD https://www.noip.com/client/linux/noip-duc-linux.tar.gz .
RUN tar vzxf noip-duc-linux.tar.gz \
 && cd noip-2.1.9-1 \
 && make

FROM alpine:edge
ENV ALPINE_VERSION=edge

LABEL maintainer="https://github.com/starwarsfan"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories
RUN apk --update upgrade \
 && apk add \
        bash \
        curl \
        expect \
        htop \
        libc6-compat \
        runit \
 && rm -rf /var/cache/apk/*

# Setup RunIt
RUN adduser -h /home/user-service -s /bin/sh -D user-service -u 2000 \
 && chown user-service:user-service /home/user-service \
 && mkdir -p /etc/run_once /etc/service

# Install entrypoint script
COPY ./boot.sh /sbin/boot.sh
RUN chmod +x /sbin/boot.sh
CMD [ "/sbin/boot.sh" ]

VOLUME ["/config"]

COPY --from=builder /no-ip/noip-2.1.9-1/noip2 /files/
COPY ["noip.conf", "create_config.exp", "/files/"]

# run-parts ignores files with "." in them
COPY parse_config_file.sh /etc/run_once/parse_config_file
RUN chmod +x /etc/run_once/parse_config_file

COPY noip.sh /etc/service/noip/run
RUN chmod +x /etc/service/noip/run
