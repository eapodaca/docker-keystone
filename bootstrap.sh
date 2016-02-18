
# Start running keystone in the background and capture its pid
keystone-all &
KEYSTONE_PID=$!

# Wait a few seconds for it to start
sleep 5

# Create the "normal" set of users and permissions
export OS_TOKEN=ADMIN
export OS_URL=http://127.0.0.1:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region regionOne identity public   http://localhost:5000/v2.0
openstack endpoint create --region regionOne identity internal http://localhost:5000/v2.0
openstack endpoint create --region regionOne identity admin    http://localhost:35357/v2.0

# Create admin project, admin user
openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default --email admin@hp.com --password admin admin
openstack role create admin
openstack role add --project admin --user admin admin
# Add admin as the cloud admin
openstack role add --domain default --user admin admin

# Create the demo project
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password demo demo
openstack role create user
openstack role add --project demo --user demo user

# Kill keystone.  It will be restarted when the packaged container is started
kill $KEYSTONE_PID
