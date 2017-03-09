FROM jupyter/datascience-notebook

MAINTAINER Olli Tourunen <olli.tourunen@csc.fi>

USER root

# OpenShift allocates the UID for the process, but GID is 0
# Based on an example by Graham Dumpleton
RUN chgrp -R root /home/$NB_USER \
    && find /home/$NB_USER -type d -exec chmod g+rwx,o+rx {} \; \
    && find /home/$NB_USER -type f -exec chmod g+rw {} \; \
    && chgrp -R root /opt/conda \
    && find /opt/conda -type d -exec chmod g+rwx,o+rx {} \; \
    && find /opt/conda -type f -exec chmod g+rw {} \;

RUN ln -s /usr/bin/env /bin/env

ENV HOME /home/$NB_USER

COPY scripts/jupyter/autodownload_and_start.sh /usr/local/bin/autodownload_and_start.sh
RUN chmod a+x /usr/local/bin/autodownload_and_start.sh

# compatibility with old blueprints, remove when not needed
RUN ln -s /usr/local/bin/autodownload_and_start.sh /usr/local/bin/bootstrap_and_start.bash

USER 1000

CMD ["/usr/local/bin/autodownload_and_start.sh"]

