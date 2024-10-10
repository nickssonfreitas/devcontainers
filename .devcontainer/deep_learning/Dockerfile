# Utiliza a imagem base de TensorFlow com suporte a GPU
FROM tensorflow/tensorflow:latest-gpu

# Definir variáveis de ambiente
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8

# Atualizar pacotes e instalar utilitários essenciais
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    git \
    wget \
    vim \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Instalar o PyTorch com suporte a GPU e outras dependências
RUN pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118

# Copiar o arquivo requirements.txt para o contêiner
COPY requirements.txt .

# Instalar dependências Python a partir do arquivo requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Instalar suporte ao SSH (opcional, para conectar a repositórios privados)
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Definir o diretório de trabalho
WORKDIR /workspace

# Expor a porta para o JupyterLab e para a API Flask (se precisar)
EXPOSE 8888   # JupyterLab
EXPOSE 5000   # Flask

# Comando padrão para iniciar o JupyterLab ao entrar no contêiner
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser"]