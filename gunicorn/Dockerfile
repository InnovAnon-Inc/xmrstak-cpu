# https://stackoverflow.com/questions/27387811/where-to-keep-dockerfiles-in-a-project
# https://stackoverflow.com/questions/50062228/django-deployment-with-nginx-gunicorn-from-another-server
FROM ubuntu:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to start the gunicorn/Django server"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

EXPOSE 8000

#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

ENV PYTHONIOENCODING UTF-8
#ENV PYTHONPATH /app/

#python3-pip python3-dev
#pip3 install django gunicorn supervisor
RUN { \
	apt-get clean ; \
	apt-get update ; \
	apt-get install -qy python-pip python-dev ; \
	pip install django gunicorn supervisor ; \
	apt-get autoremove -qy ; \
\
	mkdir /projects ; \
}

ADD projects/* /projects/
VOLUME /projects
