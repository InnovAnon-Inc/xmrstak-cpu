# https://stackoverflow.com/questions/27387811/where-to-keep-dockerfiles-in-a-project
# https://stackoverflow.com/questions/50062228/django-deployment-with-nginx-gunicorn-from-another-server
FROM ubuntu:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to start the gunicorn/Django server"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

ENV PYTHONIOENCODING UTF-8
#ENV PYTHONPATH /app/

RUN apt-get clean

RUN apt-get update
#RUN apt-get install -qy python3-pip python3-dev
#RUN pip3 install django gunicorn supervisor
RUN apt-get install -qy python-pip python-dev
RUN pip install django gunicorn supervisor

EXPOSE 8000

# TODO how to get project files onto this server ?
VOLUME /projects

RUN apt-get autoremove -qy
