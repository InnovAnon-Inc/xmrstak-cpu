#FROM nvidia/cuda:11.1-devel-ubuntu20.04 as base
#FROM nvidia/cuda:9.1-devel-ubuntu16.04 as base
FROM ubuntu:16.04 as base

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

ARG  DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND ${DEBIAN_FRONTEND}

ARG  TZ=UTC
ENV  TZ ${TZ}
ARG  LANG=C.UTF-8
ENV  LANG ${LANG}
ARG  LC_ALL=C.UTF-8
ENV  LC_ALL ${LC_ALL}

RUN apt update \
 && apt full-upgrade -y

FROM base as builder

COPY ./scripts/dpkg-dev-xmrig.list /dpkg-dev.list
RUN test -f                        /dpkg-dev.list  \
 && apt install      -y `tail -n+2 /dpkg-dev.list` \
 && rm -v                          /dpkg-dev.list

COPY ./scripts/configure-xmrig.sh /configure.sh

FROM builder as scripts
USER root

# TODO -march -mtune -U
RUN mkdir -v                /app \
 && chown -v nobody:nogroup /app
COPY            --chown=root ./scripts/healthcheck-xmrig.sh /app/healthcheck.sh
COPY            --chown=root ./scripts/entrypoint-xmr-stak.sh  /app/entrypoint.sh
WORKDIR                     /app
USER nobody

ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN shc -Drv -f healthcheck.sh   \
 && shc -Drv -f entrypoint.sh    \
 && test -x     healthcheck.sh.x \
 && test -x     entrypoint.sh.x

FROM builder as libuv
USER root

RUN git clone --depth=1 --recursive  \
    git://github.com/libuv/libuv.git \
                            /app     \
 && mkdir -v                /app/build                                  \
 && chown -v nobody:nogroup /app/build
WORKDIR                     /app
USER nobody

ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN cd       build                                                      \
 && /configure.sh                                                       \
 && cd       ..                                                         \
 && cmake --build build                                                 \
 && cd       build                                                      \
 && make DESTDIR=dest install                                           \
 && cd           dest                                                   \
 && tar vpacf ../dest.txz --owner root --group root .

FROM builder as app
USER root

COPY --chown=root --from=libuv /app/build/dest.txz /dest.txz
RUN tar vxf /dest.txz -C /                \
 && rm -v   /dest.txz                     \
 && git clone --depth=1 --recursive       \
    git://github.com/fireice-uk/xmr-stak.git \
                            /app          \
 && sed -i 's@constexpr double fDevDonationLevel = 2.0 / 100.0;@constexpr double fDevDonationLevel = 0.0 / 100.0;@' /app/xmrstak/donate-level.hpp \
 && mkdir -v                /app/build    \
 && chown -v nobody:nogroup /app/build
WORKDIR                     /app
USER nobody

ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN cd       build                                                      \
 && /configure.sh                                                       \
      -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF -DCPU_ENABLE=ON             \
      -DMICROHTTPD_ENABLE=OFF -DOpenSSL_ENABLE=ON -DHWLOC_ENABLE=ON     \
 && cd ..                                                               \
 && cmake --build build                                                 \
 && cd            build                                                 \
 && strip --strip-all bin/xmr-stak
#RUN upx --all-filters --ultra-brute cpuminer

#FROM nvidia/cuda:11.1-runtime-ubuntu20.04
FROM base
USER root

COPY --chown=root --from=libuv /app/build/dest.txz /dest.txz
COPY ./scripts/dpkg-xmrig.list     /dpkg.list
RUN test -f                        /dpkg.list  \
 && apt install      -y `tail -n+2 /dpkg.list` \
 && rm -v                          /dpkg.list  \
 && apt autoremove   -y         \
 && apt clean        -y         \
 && rm -rf /var/lib/apt/lists/* \
           /usr/share/info/*    \
           /usr/share/man/*     \
           /usr/share/doc/*     \
 && tar vxf /dest.txz -C /      \
 && rm -v /dest.txz
COPY --from=app --chown=root /app/build/bin/xmr-stak            /usr/local/bin/xmrig

ARG COIN=xmr-stak
ENV COIN ${COIN}
COPY "./mineconf/${COIN}.d/"   /conf.d/
VOLUME                         /conf.d
#COPY            --chown=root ./scripts/entrypoint-xmrig.sh  /usr/local/bin/entrypoint
COPY --from=scripts --chown=root /app/entrypoint.sh.x        /usr/local/bin/entrypoint

#COPY            --chown=root ./scripts/healthcheck-xmrig.sh /usr/local/bin/healthcheck
COPY --from=scripts --chown=root /app/healthcheck.sh.x        /usr/local/bin/healthcheck
HEALTHCHECK --start-period=30s --interval=1m --timeout=3s --retries=3 \
CMD ["/usr/local/bin/healthcheck"]

WORKDIR /conf.d
ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}
COPY           --chown=root ./scripts/test.sh              /test
RUN                                                        /test config \
 && rm -v                                                  /test

#EXPOSE 4048
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD        ["config"]

