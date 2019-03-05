# https://stackoverflow.com/questions/27387811/where-to-keep-dockerfiles-in-a-project
FROM jkarlos/git-server-docker:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to start the git (version control) server"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

#EXPOSE 2222
EXPOSE 22

#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

#RUN { \
#	apt-get clean ; \
#	apt-get update ; \
#	apt-get autoremove -qy ; \
#}

#RUN sed -i 's/^#Port 22$/Port 2222/' /etc/ssh/sshd_config

#FROM debian:wheezy
#RUN useradd foo
#RUN mkdir /data && touch /data/x
#RUN chown -R foo:foo /data
#VOLUME /data

#VOLUME /git-server/keys
#VOLUME /git-server/repos

COPY keys/* /git-server/keys/
#ADD repos/* /git-server/repos/
VOLUME /git-server/keys /git-server/repos
