FROM python:latest as builder

MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>
LABEL version="1.0"                                                     \
      maintainer="Innovations Anonymous <InnovAnon-Inc@protonmail.com>" \
      about="Dockerized Virtual Temple"                                 \
      org.label-schema.build-date=$BUILD_DATE                           \
      org.label-schema.license="PDL (Public Domain License)"            \
      org.label-schema.name="Dockerized Virtual Temple"                 \
      org.label-schema.url="InnovAnon-Inc.github.io/VirtualTemple"      \
      org.label-schema.vcs-ref=$VCS_REF                                 \
      org.label-schema.vcs-type="Git"                                   \
      org.label-schema.vcs-url="https://github.com/InnovAnon-Inc/VirtualTemple"

# localization
ARG  TZ=UTC
ENV  TZ=${TZ}
ARG  LANG=C.UTF-8
ENV  LANG=${LANG}
ARG  LC_ALL=C.UTF-8
ENV  LC_ALL=${LC_ALL}

RUN python3 -m pip install --upgrade pip    \
 && git clone --depth=1 --recursive         \
      https://github.com/LukeB42/psyrcd.git \
      /app2                                 \
 && 2to3 --output-dir=/app -W -n /app2      \
 && cp -v  /app2/psyrcd.conf                \
           /app2/requirements.txt           \
           /app                             \
 && rm -rf /app2
WORKDIR    /app

RUN echo pluginbase >> requirements.txt   \
 && python3 -m pip   install --upgrade    \
      -r requirements.txt                 \
 && python3 setup.py install --upgrade .  \
 && rm -v requirements.txt setup.py       \
 && mv -v psyrcd.py /usr/bin/psyrcd

#VOLUME  /app/conf.d

USER nobody

ENV PYTHON_ENV production
EXPOSE 6667
ENTRYPOINT ["/usr/bin/psyrcd"]
CMD        ["-f"]

