shaddock-template
===================
Typical OpenStack in Docker images to be deployed with Shaddock.

https://github.com/epheo/shaddock

The follwing architecture is currenlty relying on iptables DNAT of the 
container ports on the 172.17.0.1 IP address of the default Docker bridge.


.. code:: bash

   cat /usr/lib/systemd/system/docker.service |grep ExecStart
   
   ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2376 --ip=172.17.0.1
   --userland-proxy=false

The services API and WUI are exposed via this bridge address.


Build all services
""""""""""""""""""
.. code:: bash

   shaddock -f openstack-deployer.yml build all

Start all OpenStack services
""""""""""""""""""""""""""""
.. code:: bash

   shaddock -f openstack-deployer.yml start all



