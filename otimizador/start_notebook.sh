#!/bin/bash
set -e

# Load environment variables from .env file
if [ -f "/app/otimizador/.env" ]; then
    export $(grep -v '^#' /app/otimizador/.env | xargs)
fi

# Ensure WORKDIR is defined
if [ -z "$WORKDIR" ]; then
    echo "Error: WORKDIR is not defined in the .env file."
    exit 1
fi

# Use WORKDIR from .env
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Inicia o JupyterLab diretamente
exec jupyter lab --ip=0.0.0.0 --port=8890 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.allow_origin='*'