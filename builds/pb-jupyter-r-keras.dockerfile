FROM jupyter/r-notebook

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

RUN test -f /bin/env || ln -s /usr/bin/env /bin/env

ENV HOME /home/$NB_USER

COPY scripts/jupyter/autodownload_and_start.sh /usr/local/bin/autodownload_and_start.sh
RUN chmod a+x /usr/local/bin/autodownload_and_start.sh

RUN echo "ssh-client and less from apt" \
    && apt-get update \
    && apt-get install -y ssh-client less \
    && apt-get clean

# compatibility with old blueprints, remove when not needed
RUN ln -s /usr/local/bin/autodownload_and_start.sh /usr/local/bin/bootstrap_and_start.bash

USER $NB_USER

# install tensorflow
RUN pip --no-cache-dir install tensorflow==2.2.0

# install R keras
RUN R -e 'install.packages("vioplot", repo="http://cran.rstudio.com/")' \
 && R -e 'install.packages("devtools", repo="http://cran.rstudio.com/")' \
 && R -e 'devtools::install_github("rstudio/keras", ref = "2.3.0.0", upgrade = "always")'

CMD ["/usr/local/bin/autodownload_and_start.sh"]
