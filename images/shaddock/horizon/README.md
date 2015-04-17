Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)


```
shaddock start horizon
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
