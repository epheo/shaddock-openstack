Used in order to deploy OpenStack in Docker with the Shaddock project:

[https://github.com/epheo/shaddock](https://github.com/epheo/shaddock)

```
shaddock start qemu
```

Possible Docker usage:

```
docker run \
  -p 8775:8775 \
  -v /var/log/nova:/var/log/nova \
  -e "RABBIT_PASS=$RABBIT_PASS" \
  -e "HOST_IP=$HOST_IP" \
  --privileged
  -t shaddock/qemu
```
