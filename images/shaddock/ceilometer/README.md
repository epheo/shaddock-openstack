

Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)


```
shaddock start ceilometer
```

Possible yml configuration with Shaddock
----------------------------------------

```
- name: ceilometer
  image: shaddock/ceilometer:latest
  priority: 50
  ports:
    - 8776
  volumes:
    - mount: /var/log/ceilometer
      host_dir: /var/log/shaddock/ceilometer
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
    CEILOMETER_DBPASS: panama
    CEILOMETER_PASS: panama
```


Possible Docker usage:
---------------------

```
docker run \
  -p 9292:9292 \
  -p 4324:4324 \
  -v /var/log/ceilometer:/var/log/ceilometer \
  -e "CEILOMETER_DBPASS=$CEILOMETER_DBPASS" \
  -e "HOST_IP=$HOST_IP" \
  -e "CEILOMETER_PASS=$CEILOMETER_PASS" \
  -e "ADMIN_PASS=$ADMIN_PASS" \
  -t shaddock/keystone
```
