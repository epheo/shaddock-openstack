shaddock-template
===================
Typical OpenStack in Docker templates to be deployed with Shaddock

Configuration
~~~~~~~~~~~~~
You sould run ./set_ip.sh first in order to sed your main nic ip in
configuration.yaml.


About the compute
~~~~~~~~~~~~~~~~~
Privileged mode should be True to use kvm when deploying on baremetal.
You can change the param Privileged: to True in order to use KVM. If not qemu 
will run on software emulation.
