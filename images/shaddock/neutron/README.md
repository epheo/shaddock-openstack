Used in order to deploy OpenStack in Docker with Shaddock:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)

```
shaddock start neutron 
```
Possible yml configuration with Shaddock
----------------------------------------

```
- name: neutron
  image: shaddock/neutron:latest
  priority: 40
  ports:
    - 8774
  volumes:
    - mount: /var/log/neutron
      host_dir: /var/log/shaddock/neutron
  privileged: True
  depends-on:
    - {name: seed, status: stopped}
    - {name: mysql, port: 3306}
    - {name: rabbitmq, port: 5672}
    - {name: keystone, port: 5000, get: '/v2.0'}
    - {name: keystone, port: 35357, get: '/v2.0'}
  env:
    MYSQL_HOST_IP: <your_ip>
    KEYSTONE_HOST_IP: <your_ip>
    RABBIT_HOST_IP: <your_ip>
    NEUTRON_HOST_IP: <your_ip>
    HOST_IP: <your_ip>
    KEYSTONE_HOST_IP: <your_ip>
    MYSQL_USER: admin
    MYSQL_PASSWORD: password
    ADMIN_PASS: panama
    RABBIT_PASS: panama
    NEUTRON_DBPASS: panama
    NEUTRON_PASS: panama
```

Possible Docker usage
---------------------

```
docker run \
  -p 8774:8774 \
  -v /var/log/neutron:/var/log/neutron \
  -e "NEUTRON_DBPASS=$NEUTRON_DBPASS" \
  -e "HOST_IP=$HOST_IP" \
  -e "ADMIN_TOKEN=$ADMIN_TOKEN" \
  --privileged
  -t shaddock/neutron
```
