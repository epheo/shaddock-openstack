

Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)

Shaddock usage
--------------

```
shaddock start heat
```

Possible yml configuration with Shaddock
----------------------------------------

```
- name: heat
  image: shaddock/heat:latest
  priority: 100
  ports:
    - 8004
    - 8000
  volumes:
    - mount: /var/log/heat
      host_dir: /var/log/shaddock/heat
  depends-on:
    - {name: nova, port: 8774}
    - {name: keystone, port: 5000, get: '/v2.0'}
    - {name: keystone, port: 35357, get: '/v2.0'}
  env:
    KEYSTONE_HOST_IP: <your_ip>
    HOST_IP: <your_ip>
    MYSQL_HOST_IP: <your_ip>
    MYSQL_USER: admin
    MYSQL_PASSWORD: password
    ADMIN_PASS: panama
    RABBIT_HOST_IP: <your_ip>
    RABBIT_PASS: panama
    HEAT_PASS: panama
    HEAT_DBPASS: panama
    HEAT_DOMAIN_PASS: panama
```


Possible Docker usage:
---------------------

```
docker run \
  -p 8000:8000 \
  -p 8004:8004 \
  -v /var/log/heat:/var/log/heat \
  -e KEYSTONE_HOST_IP=<your_ip> \
  -e HOST_IP=<your_ip> \
  -e MYSQL_HOST_IP=<your_ip> \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=password \
  -e ADMIN_PASS=panama \
  -e RABBIT_HOST_IP=<your_ip> \
  -e RABBIT_PASS=panama \
  -e HEAT_PASS=panama \
  -e HEAT_DBPASS=panama \
  -e HEAT_DOMAIN_PASS=panama \
  -t shaddock/heat
```
