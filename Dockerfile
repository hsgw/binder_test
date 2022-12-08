FROM continuumio/miniconda3

# install the notebook package
RUN python -m pip install --no-cache-dir notebook jupyterlab && \
    pip install --no-cache-dir jupyterhub

# create user with a home directory
ARG NB_USER=user
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN conda create -n cadquery -c conda-forge -c cadquery python=3.10 cadquery=master

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "cadquery", "/bin/bash", "-c"]

RUN pip install --upgrade pip
RUN pip install jupyter-cadquery==3.4.0 cadquery-massembly==1.0.0rc0 matplotlib

ENTRYPOINT ["conda","run","-n","cadquery"]