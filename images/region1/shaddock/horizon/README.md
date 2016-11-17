Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)


```
shaddock start horizon
```

Possible yml configuration with Shaddock
----------------------------------------

```
- name: horizon
  image: shaddock/horizon:latest
  priority: 60
  ports:
    - 80
    - 11211
  volumes:
    - mount: /var/log/horizon
      host_dir: /var/log/shaddock/horizon
  depends-on:
    - {name: seed, status: stopped}
    - {name: mysql, port: 3306}
    - {name: keystone, port: 5000, get: '/v2.0'}
    - {name: keystone, port: 35357, get: '/v2.0'}
  env:
    KEYSTONE_API_IP: <your_ip>
```

Possible Docker usage:
---------------------

```
docker run \
  -p 80:80 \
  -p 11211:11211 \
  -v /var/log/horizon:/var/log/horizon \
  -e "HOST_IP=$HOST_IP" \
  -t shaddock/horizon
```
