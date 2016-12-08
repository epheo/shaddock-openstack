FROM shaddock/seed:arch_based
MAINTAINER epheo <github@epheo.eu> 

RUN pacman -Sy --noconfirm mariadb mariadb-clients

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

RUN groupadd -r mysql && useradd -r -g mysql mysql

ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306
