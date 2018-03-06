FROM python:3.6.4-alpine AS builder
MAINTAINER Vitor Mantovani <vtrmantovani@gmail.com>

RUN apk add --no-cache --update bash git openssh mariadb-dev libffi-dev linux-headers alpine-sdk

RUN addgroup sample-docker && adduser -D -h /home/sample-docker -G sample-docker sample-docker

USER sample-docker
RUN mkdir /home/sample-docker/sfd
RUN mkdir /home/sample-docker/logs
ADD wsgi.py /home/sample-docker/
ADD requirements.txt /home/sample-docker/
ADD sfd /home/sample-docker/sfd
ADD manager.py /home/sample-docker/

RUN cd /home/sample-docker && rm -rf /home/sample-docker/.venv && /usr/local/bin/python -m venv .venv \
    && /home/sample-docker/.venv/bin/pip install --upgrade pip
RUN cd /home/sample-docker && /home/sample-docker/.venv/bin/pip install -r requirements.txt


FROM python:3.6.4-alpine

COPY --from=builder /home/sample-docker /home/sample-docker

RUN addgroup sample-docker && adduser -D -h /home/sample-docker -G sample-docker sample-docker

USER root
RUN chown sample-docker.sample-docker /home/sample-docker -R

USER sample-docker
ADD ./dockerfiles/uwsgi.ini /home/sample-docker/

ADD ./dockerfiles/newrelic.ini /home/sample-docker/
ENV NEW_RELIC_CONFIG_FILE=/home/sample-docker/newrelic.ini

EXPOSE 8080
CMD ["/home/sample-docker/.venv/bin/newrelic-admin", "run-program", "/home/sample-docker/.venv/bin/uwsgi", "--ini", "/home/sample-docker/uwsgi.ini"]