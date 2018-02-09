FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu> 

RUN pacman -Sy --noconfirm mariadb mariadb-clients python
RUN useradd mysql

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306
