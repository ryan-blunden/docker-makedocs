FROM python:3.6-slim

MAINTAINER  Ryan Blunden <ryan.blunden@rabbitbird.com>

ENV REFREHSED_AT 2017-08-04

RUN apt-get update && \
    apt-get upgrade -y  && \
    apt-get install -y --no-install-recommends patch && \
    \
    apt-get clean && \
    apt-get purge && \
    \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

WORKDIR /usr/src/docs

RUN pip install pip --upgrade && pip install mkdocs

# Remove the host:port config in the JS live reload so live-reloading works.
# Credit: https://github.com/metal3d/docker-mkdocs/blob/master/livereload.patch
COPY livereload-server.py.patch /tmp/livereload-server.py.patch
RUN patch /usr/local/lib/python3.6/site-packages/livereload/server.py /tmp/livereload-server.py.patch 

EXPOSE 8080

ENTRYPOINT ["mkdocs"]

CMD ["serve", "--dev-addr=0.0.0.0:8080"]
