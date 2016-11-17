#!/bin/bash

echo $RABBIT_PASS

PASS=${RABBIT_PASS}
USER=${RABBIT_USER:-"guest"}

sed -i s/.*NODENAME.*/NODENAME\=rabbit\@`hostname`/ /etc/rabbitmq/rabbitmq-env.conf

cat > /etc/rabbitmq/rabbitmq.config <<EOF
[
{rabbit, [{loopback_users, []},{default_user, <<"$USER">>},{default_pass, <<"$PASS">>},{tcp_listeners, [{"0.0.0.0", 5672}]}]}
].
EOF

ulimit -n 1024
chown -R rabbitmq:rabbitmq /data
rabbitmq-server $@
