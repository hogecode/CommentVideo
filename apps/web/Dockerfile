FROM node:20-alpine

# 作業ディレクトリ
WORKDIR /app

# package.json と yarn.lock をコピーして依存関係インストール
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# ソースコードをコピー
COPY . .

# ポート設定
EXPOSE 3000

# Vite 開発サーバーを起動
CMD ["yarn", "dev", "--host", "0.0.0.0"]