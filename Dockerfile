ARG OS
ARG VER
FROM ${OS}:${VER} as base

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
ENV  DEBIAN_FRONTEND=${DEBIAN_FRONTEND}

# localization
ARG  TZ=UTC
ENV  TZ=${TZ}
ARG  LANG=C.UTF-8
ENV  LANG=${LANG}
ARG  LC_ALL=C.UTF-8
ENV  LC_ALL=${LC_ALL}

# update/upgrade
RUN apt update
RUN apt full-upgrade -y

FROM base as builder

RUN apt install      -y git build-essential autoconf automake \
  libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev libmpc-dev libmpfr-dev libisl-dev zlib1g-dev
#RUN apt install      -y lib32z1-dev

ARG REPO
ENV REPO=${REPO}

ARG CONF
ENV CONF=${CONF}

ARG CFLAGS
ARG CXXFLAGS
ENV CFLAGS=${CFLAGS}
ENV CXXFLAGS=${CXXFLAGS}

#RUN echo     "REPO=${REPO}"
#RUN echo   "CFLAGS=${CFLAGS}"
#RUN echo "CXXFLAGS=${CXXFLAGS}"

# repo
RUN git clone --depth=1 --recursive   \
   "${REPO}"                          \
   /app
# src pkg
#RUN cd /app                           \
# && tar -acf /app.txz --exclude-vcs . \
# && cd /                              \
# && rm -rf /app                       \
# && tar -xvf /app.txz -C /app         \
# && rm     /app.txz                   \
# && chown -R nobody:nogroup /app
RUN chown -R nobody:nogroup /app
WORKDIR /app
USER nobody
#RUN make distclean || echo clean
RUN rm -f config.status
#RUN ./autogen.sh || echo done
RUN chmod -v +x autogen.sh \
 && ./autogen.sh
RUN if [ "$DOCKERTAG" != ppc7450 ] ; then                                                                                  \
      ./configure --with-curl ${CONF}                                                                                      \
      CXXFLAGS="$CXXFLAGS -march=$DOCKER_TAG -mtune=$DOCKER_TAG -std=gnu++11 $CFLAGS -march=$DOCKER_TAG -mtune=$DOCKERTAG" \
      CFLAGS="$CFLAGS -march=$DOCKER_TAG -mtune=$DOCKER_TAG"                                                               \
  ; else                                                                                                                   \
      ./configure --with-curl ${CONF}                                                                                      \
      CXXFLAGS="$CXXFLAGS -mcpu=$DOCKER_TAG -std=gnu++11 $CFLAGS -mcpu=$DOCKERTAG"                                         \
      CFLAGS="$CFLAGS -mcpu=$DOCKER_TAG"                                                                                   \
  ; fi
RUN make -j`nproc`
RUN if [ ! -x cpuminer ] ; then [ -x minerd ] && ln -sv minerd cpuminer ; fi
RUN strip --strip-all cpuminer
#RUN upx --all-filters --ultra-brute cpuminer



#ARG OS
#ARG VER
#FROM ${OS}:${VER}
FROM base

#MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>
#LABEL version="1.0"                                                     \
#      maintainer="Innovations Anonymous <InnovAnon-Inc@protonmail.com>" \
#      about="Dockerized Crypto Miner"                                   \
#      org.label-schema.build-date=$BUILD_DATE                           \
#      org.label-schema.license="PDL (Public Domain License)"            \
#      org.label-schema.name="Dockerized Crypto Miner"                   \
#      org.label-schema.url="InnovAnon-Inc.github.io/docker"             \
#      org.label-schema.vcs-ref=$VCS_REF                                 \
#      org.label-schema.vcs-type="Git"                                   \
#      org.label-schema.vcs-url="https://github.com/InnovAnon-Inc/docker"

# disable interactivity
#ARG  DEBIAN_FRONTEND=noninteractive
#ENV  DEBIAN_FRONTEND=${DEBIAN_FRONTEND}

# localization
#ARG  TZ=UTC
#ENV  TZ=${TZ}
#ARG  LANG=C.UTF-8
#ENV  LANG=${LANG}
#ARG  LC_ALL=C.UTF-8
#ENV  LC_ALL=${LC_ALL}

#RUN apt update
#RUN apt full-upgrade -y
RUN apt install      -y libcurl4 libjansson4 libssl1.1 libgmp10 libmpc3 libmpfr6 libisl22 zlib1g
#RUN apt install      -y lib32z1
COPY --from=builder --chown=root /app/cpuminer /usr/local/bin/cpuminer
#USER root
#WORKDIR /

RUN localpurge                  \
  ; apt autoremove -y           \
 && apt clean      -y           \
 && rm -rf /var/lib/apt/lists/* \
           /usr/share/info/*    \
           /usr/share/man/*     \
           /usr/share/doc/*

ARG COIN
ENV COIN=${COIN}

COPY "./${COIN}.d/"       /conf.d/
VOLUME                    /conf.d
COPY  ./entrypoint.sh     /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD        ["btc"]

