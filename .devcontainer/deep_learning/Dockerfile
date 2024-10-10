# Base Image
FROM daskdev/dask-notebook:2024.8.1-py3.12

# Definir variáveis de ambiente permanentes
ENV NB_USER="jovyan"
ENV NB_UID=1000
ENV NB_GID=1000
ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONIOENCODING="utf-8"
ENV LC_ALL="C.UTF-8"
ENV JUPYTER_PORT="8888"
ENV DASK_PORT="8787"
ENV GRANT_SUDO="yes"
ENV HOME_DIR="/home/${NB_USER}"
ENV NB_PREFIX="/"
ENV SHELL="/bin/bash"

##############################################################################
# Atualização e instalação de pacotes essenciais
##############################################################################
USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
        apt-transport-https \
        apt-utils \
        build-essential \
        ca-certificates \
        curl \
        libncurses5 \
        libncursesw5 \
        patch \
        wget \
        rsync \
        unzip \
        zip \
        jq \
        gnupg \
        libtcmalloc-minimal4 \
        locales \
        nano \
        vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen

# Ajustar permissões para o diretório home do usuário existente
##############################################################################
RUN mkdir -p ${HOME_DIR} && \
    chown -R ${NB_UID}:${NB_GID} ${HOME_DIR}

##############################################################################
# Instalação do kubectl para notebooks do Kubeflow
##############################################################################
RUN curl -sL "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && \
    curl -sL "https://dl.k8s.io/v1.21.0/bin/linux/amd64/kubectl.sha256" -o /tmp/kubectl.sha256 && \
    echo "$(cat /tmp/kubectl.sha256) /usr/local/bin/kubectl" | sha256sum --check && \
    rm /tmp/kubectl.sha256 && \
    chmod +x /usr/local/bin/kubectl

##############################################################################
# Instalação do Ollama
##############################################################################
RUN mkdir -p /usr/share/ollama && chown -R root:root /usr/share/ollama
COPY /ollama/ollama /usr/bin/
RUN chmod +x /usr/bin/ollama

##############################################################################
# Instalação do Tini para inicialização eficiente
##############################################################################
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

##############################################################################
# Instalação de dependências Python
##############################################################################
COPY devcontainers/.devcontainer/dask_ollama/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

##############################################################################
# Copiar o script de inicialização e definir permissões
##############################################################################
COPY devcontainers/.devcontainer/dask_ollama/startup.sh ./
RUN chmod +x startup.sh

# Definir diretório de trabalho e permissões
WORKDIR ${HOME_DIR}
RUN chown -R ${NB_UID}:${NB_GID} ${HOME_DIR}

# Definir o usuário padrão para jovyan
USER ${NB_USER}

##############################################################################
# Expor as portas para Jupyter e Dask
##############################################################################
EXPOSE ${JUPYTER_PORT}
EXPOSE ${DASK_PORT}

##############################################################################
# Definir o ponto de entrada e comando padrão
##############################################################################
ENTRYPOINT ["tini", "--"]
CMD ["./startup.sh"]
