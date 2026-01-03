# バックエンド接続確認チェックリスト

## 1. コンテナの起動確認

```bash
# すべてのコンテナが起動しているか確認
docker compose ps

# ログを確認
docker compose logs backend
```

## 2. データベースの確認

```bash
# データベースに接続して確認
docker compose exec db psql -U postgres -d tbt_rails_development

# テーブル一覧を確認
\dt

# usersテーブルを確認
SELECT * FROM users;
```

## 3. マイグレーションの確認

```bash
# マイグレーション状態を確認
docker compose exec backend rails db:migrate:status

# マイグレーションを実行（未実行の場合）
docker compose exec backend rails db:migrate
```

## 4. APIエンドポイントの確認

### Health Check
```bash
curl http://localhost:3000/api/v1/health
```

### 新規登録（テスト）
```bash
curl -X POST http://localhost:3000/api/v1/auth/sign_up \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "test@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }'
```

### ログイン（テスト）
```bash
curl -X POST http://localhost:3000/api/v1/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "test@example.com",
      "password": "password123"
    }
  }' \
  -v
```

`-v`オプションでレスポンスヘッダーを確認し、`Authorization`ヘッダーにJWTトークンが含まれているか確認してください。

## 5. CORS設定の確認

ブラウザの開発者ツール（Networkタブ）で以下を確認：
- リクエストが送信されているか
- レスポンスヘッダーに`Authorization`が含まれているか
- CORSエラーが発生していないか

## 6. よくある問題と解決方法

### JWTトークンが取得できない
- CORS設定で`expose: ['Authorization']`が設定されているか確認
- バックエンドコンテナを再起動: `docker compose restart backend`

### 認証エラーが発生する
- JWTトークンが正しく保存されているか確認（ブラウザの開発者ツール > Application > Local Storage）
- トークンの有効期限を確認（デフォルト: 1日）

### データベースエラー
- マイグレーションが実行されているか確認
- データベースコンテナが起動しているか確認

