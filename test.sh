#! /bin/bash
set -exo nounset

UPDATE=0

if [ -z "`command -v git`" ] ; then
        sudo apt-get update
        sudo apt-get upgrade -qy
        UPDATE=1
        sudo apt-get install -qy git
fi
if [ ! -d django-on-docker ] ; then
        git clone https://github.com/testdrivenio/django-on-docker.git
fi
cd django-on-docker

if [ -z "`command -v pip3`" ] ; then
        if [ $UPDATE -eq 0 ] ; then
                sudo apt-get update
                sudo apt-get upgrade -qy
        fi
        sudo apt-get install -qy python3-pip
fi

if [ -z "`command -v docker-compose`" ] ; then
        sudo pip3 install --upgrade pip
        sudo pip3 install setuptools  docker-compose
fi
sudo docker-compose build
sudo docker-compose up -d
