FROM rocker/ropensci

MAINTAINER Olli Tourunen <olli.tourunen@csc.fi>

COPY scripts/rstudio/autodownload.sh /etc/cont-init.d/zzz-autodownload.sh

# cludge for noexec in docker 1.10 bug
# https://github.com/just-containers/s6-overlay/issues/158
VOLUME ["/run"]
