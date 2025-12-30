# TBT Rails - Rails 8 + Nuxt 3 Docker環境

Rails 8 APIとNuxt 3をDocker環境で構築したプロジェクトです。

## 構成

- **Backend**: Rails 8 (API mode)
- **Frontend**: Nuxt 3
- **Database**: PostgreSQL 16
- **Container**: Docker & Docker Compose

## セットアップ

### 1. プロジェクトの起動

```bash
# コンテナをビルドして起動
docker compose up --build

# バックグラウンドで起動
docker compose up -d
```

### 2. データベースのセットアップ

```bash
# データベースを作成
docker compose exec backend rails db:create

# マイグレーションを実行
docker compose exec backend rails db:migrate

# シードデータを投入（オプション）
docker compose exec backend rails db:seed
```

### 3. アクセス

- **Frontend (Nuxt)**: http://localhost:3001
- **Backend (Rails API)**: http://localhost:3000
- **API Health Check**: http://localhost:3000/api/v1/health

## 開発コマンド

### Rails

```bash
# コンテナ内でRailsコンソールを起動
docker compose exec backend rails console

# マイグレーションを作成
docker compose exec backend rails generate migration CreateUsers

# テストを実行
docker compose exec backend rails test
```

### Nuxt

```bash
# コンテナ内でNuxt開発サーバーを起動（既に起動中）
docker compose exec frontend npm run dev

# ビルド
docker compose exec frontend npm run build
```

## プロジェクト構造

```
tbt-rails/
├── backend/          # Rails 8 API
│   ├── app/
│   ├── config/
│   └── db/
├── frontend/         # Nuxt 3
│   ├── pages/
│   ├── components/
│   └── assets/
└── docker-compose.yml
```

## 環境変数

### Backend

- `DATABASE_HOST`: データベースホスト（デフォルト: db）
- `DATABASE_USER`: データベースユーザー（デフォルト: postgres）
- `DATABASE_PASSWORD`: データベースパスワード（デフォルト: postgres）
- `DATABASE_NAME`: データベース名（デフォルト: tbt_rails_development）

### Frontend

- `API_BASE_URL`: Rails APIのベースURL（デフォルト: http://localhost:3000）

## セキュリティ注意事項

⚠️ **本番環境で使用する場合**

- `docker-compose.yml`に含まれるデフォルトパスワード（`postgres`）は開発環境専用です
- 本番環境では必ず環境変数や`.env`ファイルを使用して、強力なパスワードを設定してください
- `.env`ファイルは`.gitignore`に含まれているため、GitHubにコミットされません

## トラブルシューティング

### コンテナの再起動

```bash
docker compose restart
```

### ログの確認

```bash
# すべてのログ
docker compose logs

# 特定のサービスのログ
docker compose logs backend
docker compose logs frontend
```

### データベースのリセット

```bash
docker compose exec backend rails db:drop db:create db:migrate
```

## ライセンス

MIT

