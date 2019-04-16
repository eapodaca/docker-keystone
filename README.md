# Docker Keystone

Runs keystone in a docker container, with sensible defaults for development and testing.

## How to run standalone

Run it in the background with:

    docker-compose up -d

or in the foreground with:

    docker-compose up

## How to use it with openstack CLI from your host

- Install python-openstackclient (using your distro's package manager)
- Source openstack.osrc
- Use commands such as `openstack token issue`

## How to use with other docker containers

One challenge with using a containerized keystone is that the URLs advertised
in keystone's catalogs will by default use the host and port numbers that
are local to this container.  But any process in another container needs
the host and port to be valid for the container network.  During the build
of the container, keystone's database will be populated with the hostname
`localhost`.  When the container is started, if the environment variable
`KEYSTONE_HOST` is passed and contains something other than `localhost`, then
the container will subsitute that value in its advertised enpoints.
