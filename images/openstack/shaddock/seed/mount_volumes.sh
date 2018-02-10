#!/bin/bash

sudo losetup /dev/loop1 /data/volumes/disk_manila_lvm1.img
sudo losetup /dev/loop0 /data/volumes/disk_cinder_lvm1.img
