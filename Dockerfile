FROM alpine:3.12.0 as builder

COPY ./requirements.txt /tmp/requirements.txt
RUN apk add --no-cache \
  py3-pip \
  python3-dev \
  openssl-dev \
  acl-dev \
  alpine-sdk \
  linux-headers

RUN pip3 install -r /tmp/requirements.txt

#

FROM alpine:3.12.0

RUN apk add --no-cache \
  msmtp \
  python3 \
  acl \
  openssl \
  openssh

COPY ./start.sh /bin/start.sh
RUN chmod 0755 /bin/start.sh
ENTRYPOINT /bin/start.sh

COPY --from=builder /usr/lib/python3.8/site-packages /usr/lib/python3.8/
COPY --from=builder /usr/bin/borg /usr/bin/borg
COPY --from=builder /usr/bin/borgmatic /usr/bin/borgmatic

VOLUME "/data"
VOLUME "/repo"
VOLUME "/conf"
