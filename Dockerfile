FROM opensuse/leap:42.3

RUN zypper addrepo -Gf https://download.opensuse.org/repositories/Cloud:/OpenStack:/Queens/openSUSE_Leap_42.3/Cloud:OpenStack:Queens.repo && \
    zypper -n update && \
    zypper -n install --force-resolution krb5 && \
    zypper -n install python-openstackclient openstack-keystone which apache2 apache2-mod_wsgi w3m lynx hostname

ADD ./wsgi-keystone.conf /etc/apache2/conf.d/wsgi-keystone.conf
ADD ./keystone.conf /etc/keystone/keystone.conf

RUN su keystone -s /bin/bash -c "keystone-manage db_sync" && \
    keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone && \
    keystone-manage bootstrap --bootstrap-password password \
        --bootstrap-username admin \
        --bootstrap-project-name admin \
        --bootstrap-role-name admin \
        --bootstrap-service-name keystone

ADD ./openstack.osrc  /
ADD ./bootstrap.sh  /usr/local/bin
RUN /usr/local/bin/bootstrap.sh

ADD ./start.sh  /usr/local/bin

EXPOSE 5000 35357

ENTRYPOINT ["/usr/local/bin/start.sh"]
