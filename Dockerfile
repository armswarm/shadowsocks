FROM alpine

ARG SHADOWSOCKS_VERSION

ADD docker-entrypoint.sh /

RUN apk add --no-cache \
      curl \
      ca-certificates \
      libev \
      libsodium \
      mbedtls \
      pcre \
      musl \
  && apk add --no-cache --virtual=.build_deps \
      autoconf \
      automake \
      libtool \
      gettext \
      pkgconf \
      mbedtls-dev \
      libsodium-dev \
      pcre-dev \
      libev-dev \
      c-ares-dev \
      asciidoc \
      xmlto \
      gcc \
      musl-dev \
      make \
      linux-headers \
  && curl -Ls https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${SHADOWSOCKS_VERSION}/shadowsocks-libev-${SHADOWSOCKS_VERSION}.tar.gz | tar zxf - \
  && cd shadowsocks-libev-${SHADOWSOCKS_VERSION}/ \
  && ./configure \
  && make \
  && make install \
  && cd .. && rm -rf shadowsocks-libev-${SHADOWSOCKS_VERSION} \
  && apk del --purge .build_deps

USER nobody

EXPOSE 8388/tcp 8388/udp 1080/tcp 1080/udp

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "server" ]
