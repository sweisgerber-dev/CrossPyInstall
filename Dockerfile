# ===========================================================================================
# Dockerfile for building AOSP [Android Open Source Project]
#
# References:
#       http://source.android.com/source/index.html
# ===========================================================================================
FROM python:3.6.6-slim-stretch

MAINTAINER Sebastian Weisgerber <sweisgerber.dev@gmail.com>

ENV GOSU_VERSION=1.10

ENV USER=pyuser
ENV USER_ID_DEFAULT=1000
ENV GROUP_ID_DEFAULT=1000

ENV WORKDIR=/workspace
ENV PYTHON_ENV=/env
ENV PYTHON_ENV_NAME="default3.6"
ENV PYTHON_ENV_NAME_EXTERNAL="external"
ENV VIRTUALENV_PATH="${PYTHON_ENV}/${PYTHON_ENV_NAME}"
ENV VIRTUALENV_PATH_EXTERNAL="${PYTHON_ENV}/${PYTHON_ENV_NAME_EXTERNAL}"


# See https://github.com/docker/docker/issues/4032
#ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gpg

COPY res/gosu.gpg /root/gosu.gpg

# Add "gosu" tool ######################################################################################################
# Alternative Import: gpg --keyserver keys.gnupg.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
RUN set -ex; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    curl -o /usr/local/bin/gosu     -SL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --import /root/gosu.gpg; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    chmod +x /usr/local/bin/gosu; \
    gosu nobody true; \
    \
    apt-get purge -y --auto-remove $fetchDeps

# Create a non-root user that will perform the actual build
RUN id ${USER} 2>/dev/null || useradd --uid ${USER_ID_DEFAULT} --create-home --shell /bin/bash ${USER}
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN mkdir ${WORKDIR} \
    mkdir ${PYTHON_ENV}
RUN chown ${USER}:${USER} ${WORKDIR}; \
    chown ${USER}:${USER} ${PYTHON_ENV}

RUN pip install \
    virtualenv

COPY config/.bashrc /home/${USER}/.bashrc
RUN chown ${USER}:${USER} /home/${USER}/.bashrc
COPY config/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN runuser -l ${USER} -c "virtualenv ${PYTHON_ENV}/${PYTHON_ENV_NAME}"

# EXPOSE ###############################################################################################################
VOLUME [ \
    "${WORKDIR}", \
    "${VIRTUALENV_PATH_EXTERNAL}"]
WORKDIR ${WORKDIR}

#RUN chown ${USER}:${USER} /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
