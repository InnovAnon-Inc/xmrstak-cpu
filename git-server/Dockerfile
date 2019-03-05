# https://stackoverflow.com/questions/27387811/where-to-keep-dockerfiles-in-a-project
FROM jkarlos/git-server-docker:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to start the git (version control) server"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

#RUN apt-get clean

VOLUME git-server/keys
VOLUME git-server/repos

EXPOSE 2222

RUN sed -i 's/^#Port 22$/Port 2222/' /etc/ssh/sshd_config

#RUN apt-get autoremove -qy
