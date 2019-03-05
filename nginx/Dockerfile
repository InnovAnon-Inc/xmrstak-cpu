# https://stackoverflow.com/questions/27387811/where-to-keep-dockerfiles-in-a-project
# https://askubuntu.com/questions/707621/official-docker-image-for-ubuntu-server
FROM nginx:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to start the nginx (www) proxy"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

#RUN { \
#	apt-get clean ; \
#	apt-get update ; \
#	apt-get autoremove -qy ; \
#}

# TODO point to gunicorn/django server

