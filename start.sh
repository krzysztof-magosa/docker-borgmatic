#!/bin/sh

cat >/etc/msmtprc <<EOF
auth            ${MAIL_AUTH}
tls             ${MAIL_TLS}
tls_starttls    ${MAIL_TLS_STARTTLS}
host            ${MAIL_HOST}
port            ${MAIL_PORT}
from            ${MAIL_FROM}
user            ${MAIL_USER}
password        ${MAIL_PASSWORD}
EOF

ln -snf /usr/bin/msmtp /usr/sbin/sendmail

[ -d /conf/borgmatic ] && ln -snf /conf/borgmatic /etc/borgmatic
[ -d /conf/borgmatic.d ] && ln -snf /conf/borgmatic.d /etc/borgmatic.d
[ -d /conf/ssh ] && ln -snf /conf/ssh /root/.ssh

echo "MAILTO=${MAIL_TO}" | cat - /conf/crontab | crontab -
exec /usr/sbin/crond -f -d 6
