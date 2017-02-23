FROM rocker/rstudio

MAINTAINER Olli Tourunen <olli.tourunen@csc.fi>

COPY scripts/rstudio/autodownload_and_configure.sh /etc/cont-init.d/zzz-autodownload-and-configure.sh

# cludge for noexec in docker 1.10 bug
# https://github.com/just-containers/s6-overlay/issues/158
VOLUME ["/run"]
