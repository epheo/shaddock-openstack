FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm wget

ADD create-cirros-image.sh /usr/bin/
ADD create-demo-project.sh /usr/bin/
ADD create-demo-user.sh /usr/bin/
ADD create-nova-flavor.sh /usr/bin/
