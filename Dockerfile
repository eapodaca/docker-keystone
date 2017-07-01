FROM ubuntu:15.10

MAINTAINER Gary Smith <gary.smith@hpe.com>

# Deal with the corporate proxy
COPY 01proxy /etc/apt/apt.conf.d

RUN apt-get update
RUN apt-get install -y keystone supervisor

RUN easy_install pip
RUN pip install --upgrade pbr
RUN pip install python-openstackclient

RUN keystone-manage db_sync

COPY bootstrap.sh /
RUN /bootstrap.sh

# Reduce size of this image
# RUN apt-get clean
# RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 5000 35357

CMD ["/usr/bin/keystone-all"]
