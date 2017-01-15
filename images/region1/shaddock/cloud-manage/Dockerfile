FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm wget

ADD create-flavor.sh /usr/bin/
ADD create-keypair.sh /usr/bin/
ADD create-image.sh /usr/bin/
ADD create-network-flat.sh /usr/bin
ADD create-security-group.sh /usr/bin/
ADD create-demo-project.sh /usr/bin/
ADD create-demo-user.sh /usr/bin/
