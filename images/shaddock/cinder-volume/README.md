
Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)



Prerequisites
-------------

Create a LVM volume group cinder-volumes:

```
sudo mkdir /var/lib/images
sudo dd if=/dev/zero of=/var/lib/images/disk_lvm1.img bs=1M count=40000
loop=$(sudo losetup  --show --find /var/lib/images/disk_lvm1.img); echo "$loop"
sudo pvcreate "$loop"
sudo vgcreate cinder-volumes "$loop"
```


Possible yml configuration with Shaddock
----------------------------------------

```
- name: cinder-volume
  image: weezhard/cinder-volume:latest
  volumes:
    - mount: /var/log/cinder
      host_dir: /var/log/shaddock/volume
  privileged: True
  network_mode: host
  priority: 75
  depends-on:
    - {name: mysql, port: 3306}
    - {name: keystone, port: 5000, get: '/v3'}
    - {name: keystone, port: 35357, get: '/v3'}
    - {name: cinder}
  env:
    KEYSTONE_HOST_IP: <your_ip>
    RABBIT_HOST_IP: <your_ip>
    MYSQL_HOST_IP: <your_ip>
    GLANCE_HOST_IP: <your_ip>
    CINDER_HOST_IP: <your_ip>
    HOST_IP: <your_ip>
    RABBIT_PASS: panama
    CINDER_DBPASS: panama
    CINDER_PASS: panama
```

```
shaddock start cinder
```


Possible Docker usage:
---------------------

```
docker run \
  -v /:/rootfs:ro \
  -v /sys:/sys:ro \
  -v /dev:/dev:rw \
  -v /var/lib/docker/:/var/lib/docker:ro \
  -v /var/run:/var/run:rw \
  -v /var/log/cinder:/var/log/cinder \
  --env-file=./env.list \
  --net=host \
  --pid=host \
  --privileged=true \
  t shaddock/cinder-volume
```
