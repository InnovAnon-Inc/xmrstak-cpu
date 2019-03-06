FROM ubuntu:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to test exposed/published ports on a server"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

EXPOSE 1000

#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

RUN { \
	apt-get clean ; \
	apt-get update ; \
	apt-get install -qy netcat ; \
	apt-get autoremove -qy ; \
}

#	mkdir /projects ; \
#ADD projects/* /projects/
#VOLUME /projects

COPY start.sh /
#ENTRYPOINT ["/bin/sh", "/start.sh"]
CMD ["/bin/sh", "/start.sh"]
