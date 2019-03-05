# https://stackoverflow.com/questions/27387811/where-to-keep-dockerfiles-in-a-project
# https://www.techrepublic.com/article/how-to-deploy-and-use-a-mysql-docker-container/?fbclid=IwAR0hQbrrf8FKlGZNXzO4ofNFTskYYtqyLBWUlhLK09AHdSrs4FeCxjxbaes
# https://stackoverflow.com/questions/28513058/docker-mysql-host-volume
FROM mysql/mysql-server:latest

MAINTAINER lynntech, inc.
LABEL Description="This image is used to start the MySQL (database) server"
LABEL Vendor="Lynntech, Inc."
LABEL Version="1.0.0-alpha"

#RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

#RUN { \
#	apt-get clean ; \
#	apt-get update ; \
#	apt-get autoremove -qy ; \
#}

# TODO set root password, create database and tables
#RUN MSTR='[Entrypoint] GENERATED ROOT PASSWORD: '
# TODO can't run docker from inside docker container
#RUN PASS="`docker logs mysql-server | \
#grep -o "^$MSTR.*" | \
#sed "s/^$MSTR//"`"
# TODO can't see mysql.cmd file from inside docker container
#RUN mysql -uroot "-p$PASS" < mysql.cmd

