FROM jupyter/minimal-notebook

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

RUN echo "ssh-client and less from apt" \
    && apt-get update \
    && apt-get install -y ssh-client less \
    && echo "install ImageMagick, disable policy restrictions" \
    && apt-get install -y imagemagick && rm -f /etc/ImageMagick-6/policy.xml \
    && apt-get clean

COPY scripts/jupyter/autodownload_and_start.sh /usr/local/bin/autodownload_and_start.sh
RUN chmod a+x /usr/local/bin/autodownload_and_start.sh

USER $NB_USER
ENV HOME /home/$NB_USER

# Switch to python 3.6 for myqlm
RUN conda install python=3.6

# Install myqlm and visualization support. See https://myqlm.github.io/myqlm_specific/install.html
RUN pip install myqlm==1.1.6 && python -m qat.magics.install

CMD ["/usr/local/bin/autodownload_and_start.sh"]
