# https://stackoverflow.com/questions/27387811/where-to-keep-dockerfiles-in-a-project
# https://stackoverflow.com/questions/50062228/django-deployment-with-nginx-gunicorn-from-another-server
FROM ubuntu:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to start the gunicorn/Django server"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

RUN apt-get update
#RUN apt-get install -y python3-pip python3-dev
#RUN pip3 install django gunicorn supervisor
RUN apt-get install -y python-pip python-dev
RUN pip install django gunicorn supervisor

EXPOSE 8000

# TODO how to get project files onto this server ?
VOLUME /projects
