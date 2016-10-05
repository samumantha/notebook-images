FROM rocker/ropensci

MAINTAINER Olli Tourunen <olli.tourunen@csc.fi>

COPY bootstrap.sh /etc/cont-init.d/zzz-bootstrap.sh

# cludge for noexec in docker 1.10 bug
# https://github.com/just-containers/s6-overlay/issues/158
VOLUME ["/run"]
