FROM rocker/ropensci

MAINTAINER Olli Tourunen <olli.tourunen@csc.fi>

COPY bootstrap.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/bootstrap.sh

COPY bootstrap.conf /tmp/

RUN cat /tmp/bootstrap.conf >> /etc/supervisor/conf.d/supervisord.conf

RUN rm /tmp/bootstrap.conf