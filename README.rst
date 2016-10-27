OpenStack architecture and processing model for Shaddock.
=========================================================
https://github.com/epheo/shaddock

All notions and objects of this repository are abstract and redefinable.

**The venv-builder** will build all the openstack projects from the upstream 
git branch you want.
It build them in parallel in sparated containers if you "start all".

shaddock -f openstack-venv-builder.yml -i venv-builder {-d host.yml}
(shaddock) build keystone
(shaddock) start keystone


**The config-processor** will parse your j2 configuration files and configure
the python venv previously created.
It take the last one built by default but you can set a specific version in 
your openstack-config-processor.yml
The jin

shaddock -f openstack-config-processor.yml -i config-processor {-d host.yml}
(shaddock) build keystone
(shaddock) start keystone

**The deployer** will manage all the docker hosts from your platform.


shaddock -f openstack-deployer.yml -i region1 {-d host.yml}
(shaddock) build keystone
(shaddock) start keystone

