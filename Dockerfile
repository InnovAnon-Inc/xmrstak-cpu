#ARG OS
#ARG VER
#FROM ${OS}:${VER} as base
FROM ubuntu:latest as base

MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>
LABEL version="1.0"                                                     \
      maintainer="Innovations Anonymous <InnovAnon-Inc@protonmail.com>" \
      about="Dockerized Crypto Miner"                                   \
      org.label-schema.build-date=$BUILD_DATE                           \
      org.label-schema.license="PDL (Public Domain License)"            \
      org.label-schema.name="Dockerized Crypto Miner"                   \
      org.label-schema.url="InnovAnon-Inc.github.io/docker"             \
      org.label-schema.vcs-ref=$VCS_REF                                 \
      org.label-schema.vcs-type="Git"                                   \
      org.label-schema.vcs-url="https://github.com/InnovAnon-Inc/docker"

# disable interactivity
ARG  DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND ${DEBIAN_FRONTEND}

# localization
ARG  TZ=UTC
ENV  TZ ${TZ}
ARG  LANG=C.UTF-8
ENV  LANG ${LANG}
ARG  LC_ALL=C.UTF-8
ENV  LC_ALL ${LC_ALL}

# update/upgrade
RUN apt update \
 && apt full-upgrade -y

FROM base as builder

# build-deps
RUN apt install      -y git build-essential autoconf automake \
  libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev libmpc-dev libmpfr-dev libisl-dev zlib1g-dev
#RUN apt install      -y lib32z1-dev

ARG REPO
ENV REPO ${REPO}

ARG CONF
ENV CONF ${CONF}

ARG CFLAGS
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG
ENV DOCKER_TAG ${DOCKER_TAG}

# repo
RUN git clone --depth=1 --recursive   \
   "${REPO}"                          \
   /app                               \
 && chown -R nobody:nogroup /app
WORKDIR /app
USER nobody

# sanity check
#RUN echo $DOCKER_TAG
#RUN if [ "$DOCKER_TAG" != 7450 ] ; then                                                                                  \
#      echo ./configure --with-curl ${CONF}                                                                                       \
#      CXXFLAGS="$CXXFLAGS -std=gnu++11 $CFLAGS -march=$DOCKER_TAG -mtune=$DOCKER_TAG" \
#      CFLAGS="$CFLAGS -march=$DOCKER_TAG -mtune=$DOCKER_TAG"                                                                \
#  ; else                                                                                                                    \
#      echo ./configure --with-curl ${CONF}                                                                                       \
#      CXXFLAGS="$CXXFLAGS -std=gnu++11 -mcpu=$DOCKER_TAG"                                         \
#      CFLAGS="-mcpu=$DOCKER_TAG"                                                                                    \
#  ; fi

# compile
# TODO ppc cross compiler
RUN rm -f config.status    \
 && chmod -v +x autogen.sh \
 && ./autogen.sh           \
 && if [ "$DOCKER_TAG" != 7450 ] ; then                                                                                  \
      ./configure --with-curl ${CONF}                                                                                       \
      CXXFLAGS="$CXXFLAGS -std=gnu++11 $CFLAGS -march=$DOCKER_TAG -mtune=$DOCKER_TAG" \
      CFLAGS="$CFLAGS -march=$DOCKER_TAG -mtune=$DOCKER_TAG"                                                                \
  ; else                                                                                                                    \
      ./configure --with-curl ${CONF}                                                                                       \
      CXXFLAGS="$CXXFLAGS -std=gnu++11 -mcpu=$DOCKER_TAG"                                         \
      CFLAGS="-mcpu=$DOCKER_TAG"                                                                                    \
  ; fi \
 && make -j`nproc` \
 && if [ ! -x cpuminer ] ; then [ -x minerd ] && ln -sv minerd cpuminer ; fi \
 && strip --strip-all cpuminer
#RUN upx --all-filters --ultra-brute cpuminer

#ARG OS
#ARG VER
#FROM ${OS}:${VER}
FROM base
WORKDIR /
USER root

# runtime-deps
#RUN apt install      -y lib32z1
RUN apt install      -y libcurl4 libjansson4 libssl1.1 libgmp10 libmpc3 libmpfr6 libisl22 zlib1g \
 && apt autoremove   -y         \
 && apt clean        -y         \
 && rm -rf /var/lib/apt/lists/* \
           /usr/share/info/*    \
           /usr/share/man/*     \
           /usr/share/doc/*
COPY --from=builder --chown=root /app/cpuminer   /usr/local/bin/cpuminer

ARG COIN
ENV COIN ${COIN}

COPY "./${COIN}.d/"       /conf.d/
VOLUME                    /conf.d
COPY                --chown=root ./entrypoint.sh /usr/local/bin/entrypoint
USER nobody

#EXPOSE 4048
COPY --chown=root ./healthcheck.sh /usr/local/bin/healthcheck
HEALTHCHECK --start-period=30s --interval=1m --timeout=3s --retries=3 \
CMD ["/usr/local/bin/healthcheck"]

ENTRYPOINT ["/usr/local/bin/entrypoint"]
#CMD        ["btc"]
CMD        ["default"]

