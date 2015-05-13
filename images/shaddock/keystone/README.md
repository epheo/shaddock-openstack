Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)

```
shaddock start keystone
```
Possible yml configuration with Shaddock
----------------------------------------

```
- name: keystone
  image: shaddock/keystone:latest
  priority: 30
  ports:
    - 35357
    - 5000
  volumes:
    - mount: /var/log/keystone
      host_dir: /var/log/shaddock/keystone
  depends-on:
    - {name: mysql, port: 3306}
  env:
    MYSQL_HOST_IP: <your_ip>
    MYSQL_USER: admin
    MYSQL_PASSWORD: password
    KEYSTONE_DBPASS: panama
    ADMIN_TOKEN: panama
```

Possible Docker usage
---------------------
```
docker run \
  -p 35357:35357 \
  -p 5000:5000 \
  -v /var/log/keystone:/var/log/keystone \
  -e "KEYSTONE_DBPASS=$KEYSTONE_DBPASS" \
  -e "HOST_IP=$HOST_IP" \
  -e "ADMIN_TOKEN=$ADMIN_TOKEN" \
  -t shaddock/keystone
```
