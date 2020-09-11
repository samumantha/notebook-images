# Base image obtained from notebooks-prod-2 and tagged as csc/r-data-analysis:2020-09-11
# Then it was rebuilt adding a layer with the standard autodownload script.

# NOTE: this build does *not* work on its own, it is only for reference

FROM csc/r-data-analysis:2020-09-11

MAINTAINER Olli Tourunen <olli.tourunen@csc.fi>

COPY scripts/rstudio/autodownload_and_configure.sh /etc/cont-init.d/zzz-autodownload-and-configure.sh
