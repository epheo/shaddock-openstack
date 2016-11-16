#!/bin/bash
dd if=/dev/zero of=/data/volumes/disk_cinder_lvm1.img bs=1M count=20000
loop=$(sudo losetup  --show --find /data/volumes/disk_cinder_lvm1.img); \
  pvcreate "$loop" && vgcreate cinder-volumes "$loop"

dd if=/dev/zero of=/data/volumes/disk_manila_lvm1.img bs=1M count=20000
loop=$(sudo losetup  --show --find /data/volumes/disk_manila_lvm1.img); \
  pvcreate "$loop" && vgcreate manila-volumes "$loop"
