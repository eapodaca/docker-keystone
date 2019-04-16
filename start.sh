#!/bin/bash

# The endopint URLs are supposed to be externally routable, but in situations where
# the ports are not exposed to the host, the container's hostname should be used
# instead.  In this case, then variable KEYSTONE_HOST should be passed as an environment
# variable to the container when started
if [[ -n $KEYSTONE_HOST && $KEYSTONE_HOST != localhost ]] ; then

    # This takes so long that it is probably better to manipulate the database directly
    #
    /usr/sbin/apache2ctl start

    source /openstack.osrc

    # Capture the IDs of the current endpoints so that we can remove them after
    # adding new ones
    oldids=$(openstack  endpoint list -c ID -f value | xargs)
    
    openstack <<EOF
    endpoint create --region region1 identity internal http://$KEYSTONE_HOST:5000/v3
    endpoint create --region region1 identity admin http://$KEYSTONE_HOST:5000/v3
    endpoint create --region region1 identity public http://$KEYSTONE_HOST:5000/v3
    endpoint delete $oldids
EOF

    /usr/sbin/apache2ctl stop

fi

pidfile=/run/httpd.pid
if [[ -f $file ]] ; then
    echo $file exists
    cat $file
    rm $file
fi

exec /usr/sbin/apache2ctl -D FOREGROUND
