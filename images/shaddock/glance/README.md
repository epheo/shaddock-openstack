

Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)


```
shaddock start glance
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
