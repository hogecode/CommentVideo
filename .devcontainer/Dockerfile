FROM mcr.microsoft.com/devcontainers/go:latest

# Node.js のインストール（Vite React 開発用）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Yarn のインストール
RUN npm install -g yarn

# 開発用ツールのインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    ca-certificates \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Go 開発ツール
RUN go install github.com/cosmtrek/air@latest && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
    go install github.com/swaggo/swag/cmd/swag@latest && \
    go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install github.com/mfridman/tparse@latest && \
    go install github.com/amacneil/dbmate@latest

# Caddy のインストール（HTTPS リバースプロキシ用）
RUN apt-get update && apt-get install -y caddy && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリ
WORKDIR /workspace

# VS Code Server サポート
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN usermod -aG docker vscode

CMD ["/bin/bash"]
