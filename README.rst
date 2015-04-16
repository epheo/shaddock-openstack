shaddock-template
===================
Typical OpenStack in Docker templates to be deployed with Shaddock

https://github.com/epheo/shaddock

Configuration
~~~~~~~~~~~~~
You sould run ./set_ip.sh first in order to sed your main nic ip in
configuration.yaml.


Currently implemented OpenStack services
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**OpenStack core:**

* Keystone
* Nova
* Glance
* Horizon

**Dependencies:**

* RabbitMq
* Mysql

**Stackforge:**

* Mistral

About the compute
~~~~~~~~~~~~~~~~~
Privileged mode should be True to use kvm when deploying on baremetal.
You can change the param Privileged: to True in order to use KVM. If not qemu
will run on software emulation.
