

Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)


```
shaddock start glance
```

Possible yml configuration with Shaddock
----------------------------------------

```
- name: glance
  image: shaddock/glance:latest
  priority: 50
  ports:
    - 9292
    - 9191
  volumes:
    - mount: /var/log/glance
      host_dir: /var/log/shaddock/glance
  depends-on:
    - {name: seed, status: stopped}
    - {name: mysql, port: 3306}
    - {name: keystone, port: 5000, get: '/v2.0'}
    - {name: keystone, port: 35357, get: '/v2.0'}
  env:
    MYSQL_HOST_IP: <your_ip>
    KEYSTONE_HOST_IP: <your_ip>
    MYSQL_USER: admin
    MYSQL_PASSWORD: password
    ADMIN_PASS: panama
    GLANCE_DBPASS: panama
    GLANCE_PASS: panama
```


Possible Docker usage:
---------------------

```
docker run \
  -p 9292:9292 \
  -p 4324:4324 \
  -v /var/log/glance:/var/log/glance \
  -e "GLANCE_DBPASS=$GLANCE_DBPASS" \
  -e "HOST_IP=$HOST_IP" \
  -e "GLANCE_PASS=$GLANCE_PASS" \
  -e "ADMIN_PASS=$ADMIN_PASS" \
  -t shaddock/keystone
```
