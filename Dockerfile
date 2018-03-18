FROM quay.io/armswarm/alpine:3.7

ARG SHADOWSOCKS_PACKAGE

ADD docker-entrypoint.sh /

RUN apk add --no-cache -X https://ftp.acc.umu.se/mirror/alpinelinux.org/edge/testing \
        shadowsocks-libev=${SHADOWSOCKS_PACKAGE}

USER nobody

EXPOSE 8388/tcp 8388/udp 1080/tcp 1080/udp

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "server" ]
