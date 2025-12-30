FROM ruby:3.3-alpine

# 必要なパッケージをインストール
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    yaml-dev \
    nodejs \
    npm \
    tzdata \
    git \
    curl

WORKDIR /app

# Gemfileをコピーしてbundle install
COPY Gemfile ./
RUN bundle install

# アプリケーションコードをコピー
COPY . .

# ポートを公開
EXPOSE 3000

# デフォルトコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]

