Used in order to deploy OpenStack in Docker with Shaddock:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)

```
shaddock start nova 
```

Possible Docker usage:

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
