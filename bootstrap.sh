/usr/sbin/apache2ctl start

export OS_TOKEN=token
export OS_URL=http://localhost:35357/v3
export OS_IDENTITY_API_VERSION=3

# Create service and endpoints
openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region region1 identity public http://localhost:5000/v3
openstack endpoint create --region region1 identity internal http://localhost:5000/v3
openstack endpoint create --region region1 identity admin http://localhost:35357/v3

source /openstack.osrc

# Set the admin's default project to be admin
openstack user set --project admin admin

# Create the user dev as another admin
openstack user create --project admin --password password --enable dev
openstack role add --project admin --user dev admin  
openstack role add --domain default --user dev admin

# Create the user 'user' as a non-admin admin
openstack user create --project admin --password password --enable user
openstack role add --project admin --user user _member_

/usr/sbin/apache2ctl stop
