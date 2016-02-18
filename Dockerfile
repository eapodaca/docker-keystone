FROM ubuntu:15.04

MAINTAINER Gary Smith <gary.smith@hpe.com>

RUN apt-get update
RUN apt-get install -y keystone supervisor

RUN easy_install pip
RUN pip install --upgrade pbr
RUN pip install python-openstackclient

RUN keystone-manage db_sync

COPY bootstrap.sh /
RUN /bootstrap.sh

EXPOSE 5000 35357

CMD ["/usr/bin/keystone-all"]
