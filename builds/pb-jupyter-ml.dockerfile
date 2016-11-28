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

RUN ln -s /usr/bin/env /bin/env

ENV HOME /home/$NB_USER

COPY scripts/jupyter/autodownload_and_start.sh /usr/local/bin/autodownload_and_start.sh
RUN chmod a+x /usr/local/bin/autodownload_and_start.sh

RUN echo "graphviz from apt" \
    && apt-get update \
    && apt-get install -y graphviz \
    && apt-get clean

RUN echo "Tensorflow" \
    && pip --no-cache-dir install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.11.0-cp35-cp35m-linux_x86_64.whl

USER 1001

RUN echo "Theano and Keras" \
    && pip --no-cache-dir install Theano \
    && pip --no-cache-dir install PyYAML seaborn keras \
    && true

RUN echo "pydot and pydot-ng" \
    && pip --no-cache-dir install pydot pydot-ng\
    && true

CMD ["/usr/local/bin/autodownload_and_start.sh"]
