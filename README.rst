OpenStack definition model for Shaddock
=========================================================

A yml definition model example you can use with Shaddock to build, deploy and
manage the lifecycle of an OpenStack platform from the upstream git sources.

http://shaddock.epheo.eu

All notions and objects of this repository are abstract and redefinable.

Deploying from the upstream sources
-------------------------------------

**The venv-builder** will build all the openstack projects from the upstream 
git branch you want.
It build them in parallel in separated containers if you "start all".
You will find the venv directories and Python sources in the
/opt/openstack/venv directory.

.. code:: bash

    shdk -c venv-builder
    (shdk) build
    (shdk) start

And wait until all the containers stop to find your venv built in 
/opt/openstack/venv/

As this can be very ressource consuming, it's recommended to add ``priority``
and ``depends-on`` statements to your builders description.

http://shdk.epheo.eu/#using-the-scheduler

To specify the OpenStack version to build, change the git branch to
clone in a global jinja2 variable like the following for Pike stable:

.. code:: yaml

    - name: venv-builder
      hosts: !include hosts/all.yml
      vars:
        git_branch: 'master'
      images: images/venv-builder/
      services:       
          - name: nova-builder
            image: shaddock/generic-pyvenv-builder:latest
            priority: 10
            volumes:
              - /opt/openstack:/opt/openstack
            environment:
              GIT_URL: https://github.com/openstack/nova.git
              GIT_BRANCH: '{{ git_branch }}'


**The deployer** will manage the lifecycle of the OpenStack services of your
platform.

.. code:: bash

    shdk -c openstack-upstream 
    (shdk) build
    (shdk) start

Before deploying you may want to edit the global variables in the 
vars/default.yml file.

**Authenticating:**
cat /opt/openstack/service.osrc


Deploying Mitaka using .deb binaries
-------------------------------------

This cluster is relaying on a Ubuntu 14.04 base image to install OpenStack 
Mitaka from the .deb binary packages.

.. code:: bash

    shdk -c openstack-ubuntu-mitaka
    (shdk) build
    (shdk) start
