OpenStack architecture and processing model for Shaddock.
=========================================================
https://github.com/epheo/shaddock

All notions and objects of this repository are abstract and redefinable.

**The venv-builder** will build all the openstack projects from the upstream 
git branch you want.
It build them in parallel in separated containers if you "start all".
You will find the venv directories and Python sources in the
/opt/openstack/venv directory.

.. code:: bash

    shaddock -f openstack-venv-builder.yml
    (shaddock) build all
    (shaddock) start all

To specify the OpenStack version to build, change the git branch to
clone in a global jinja2 variable like the following for Newton stable:

.. code:: yaml

    - name: venv-builder
      hosts: !include hosts/all.yml
      vars:
        git_branch: 'stable/newton'
      images: images/venv-builder/
  
      services:       
          - name: nova
            image: shaddock/generic-pyvenv-builder:latest
            priority: 10
            volumes:
              - mount: /opt/openstack
                host_dir: /opt/openstack
            env:
              GIT_URL: https://github.com/openstack/nova.git
              GIT_BRANCH: '{{ git_branch }}'

**The deployer** will manage the lifecycle of all the OpenStack services of 
your platform.

.. code:: bash

    shaddock -f openstack-deployer.yml
    (shaddock) build all
    (shaddock) start all

Before deploying you may want to edit the global variables in the 
vars/default.yml file.


