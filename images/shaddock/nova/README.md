Used in order to deploy OpenStack in Docker with Shaddock:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)

```
shaddock start nova 
```
Possible yml configuration with Shaddock
----------------------------------------

```
- name: nova
  image: shaddock/nova:latest
  priority: 40
  ports:
    - 8774
  volumes:
    - mount: /var/log/nova
      host_dir: /var/log/shaddock/nova
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
    NOVA_HOST_IP: <your_ip>
    HOST_IP: <your_ip>
    KEYSTONE_HOST_IP: <your_ip>
    MYSQL_USER: admin
    MYSQL_PASSWORD: password
    ADMIN_PASS: panama
    RABBIT_PASS: panama
    NOVA_DBPASS: panama
    NOVA_PASS: panama
```

Possible Docker usage
---------------------

```
docker run \
  -p 8774:8774 \
  -v /var/log/nova:/var/log/nova \
  -e "NOVA_DBPASS=$NOVA_DBPASS" \
  -e "HOST_IP=$HOST_IP" \
  -e "ADMIN_TOKEN=$ADMIN_TOKEN" \
  --privileged
  -t shaddock/nova
```
