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

PASS=password
DOM=default
PROJ=admin

# Create _member_ role, which is absent
openstack role create _member_

# Create user 'dev' as administrator of Default domain and admin project
USER=dev
openstack user create --project $PROJ --password $PASS --enable $USER
openstack role add --project $PROJ --user $USER admin  
openstack role add --domain $DOM --user $USER admin

# Create user 'user' as a member of admin project and Default domain
USER=user
openstack user create --project $PROJ --password $PASS --enable $USER
openstack role add --project $PROJ --user $USER _member_
openstack role add --domain $DOM --user $USER _member_

PROJ=p
openstack project create $PROJ

# Create user 'dda' as administrator of Default domain and member of project 'p'
USER=dda
openstack user create --project $PROJ --password $PASS --enable $USER
openstack role add --domain $DOM --user $USER admin
openstack role add --project $PROJ --user $USER _member_

# Create user 'pa' as administrator of project p (but not of any domain)
USER=pa
openstack user create --project $PROJ --password $PASS --enable $USER
openstack role add --domain $DOM --user $USER _member_
openstack role add --project $PROJ --user $USER admin

/usr/sbin/apache2ctl stop
