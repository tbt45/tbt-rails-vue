FROM node:20-alpine

WORKDIR /app

# パッケージファイルをコピーしてインストール
COPY package*.json ./
RUN npm install

# アプリケーションコードをコピー
COPY . .

# ポートを公開
EXPOSE 3000

# 開発環境用のデフォルトコマンド
CMD ["npm", "run", "dev"]

