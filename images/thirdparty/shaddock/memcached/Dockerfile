FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu>

RUN pacman -Sy --noconfirm python2-memcached memcached

RUN useradd daemon

EXPOSE 11211
