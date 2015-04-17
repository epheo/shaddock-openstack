Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)

```
shaddock start keystone
```

Possible Docker usage:

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
