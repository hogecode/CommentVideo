# CommePlayer バックエンド - 開発ガイド

## ディレクトリ構成

```
server/
├── cmd/
│   └── main.go         # エントリポイント
├── db/
│   ├── migrations/      # SQLite マイグレーション
│   └── schema.sql       # DB スキーマ定義
├── internal/
│   ├── api/             # API ハンドラー
│   ├── models/          # データモデル
│   ├── repository/      # DB アクセス層
│   └── service/         # ビジネスロジック
├── go.mod              # モジュール定義
├── go.sum              # 依存関係ロック
└── .golangci.yml       # リント設定
```

## 開発ワークフロー

### 開発サーバーの起動

```bash
cd server
go mod download        # 依存関係をダウンロード
go run ./cmd/main.go   # サーバー起動

# または Makefile を使用（ホットリロード）
make server-run        # air による自動リロード
```

### コード品質チェック

```bash
# フォーマット（必須）
make server-fmt        # goimports による import 整理 + go fmt

# リント（本番デプロイ前に実行）
make server-lint       # golangci-lint

# テスト
make server-test       # go test -race ./...
```


## データベース操作

### マイグレーション

```bash
# マイグレーション実行
make db-migrate

# 新規マイグレーション作成（使用法）
make db-new name=create_videos

# スキーマをファイルにダンプ
make db-dump
```


## ログ出力

```go
// 英語で記述（必須）
log.Info("starting server", "port", 8000)
log.WithError(err).Error("database connection failed")

// Log レベル（推奨）
log.Debug("detailed info for debugging")     // 開発時のみ
log.Info("important events")                  // デフォルト
log.Warn("potentially problematic situations") // 警告
log.Error("error conditions")                 // エラー
```

## テスト

```bash
# テスト実行
make server-test

# カバレッジを確認
go test -cover ./...

# 特定のテストのみ実行
go test -run TestVideoHandler ./...
```


## パフォーマンス

### 最適化チェックリスト
- [ ] N+1 クエリを避ける（JOIN を使用）
- [ ] インデックスを適切に設定
- [ ] ゴルーチンのリーク確認
- [ ] メモリリーク確認（`pprof`）
- [ ] 大量データ処理時はストリーミング対応

### プロファイリング

```go
import _ "net/http/pprof"

// http://localhost:8000/debug/pprof/heap にアクセス
```

## 環境変数

```bash
# .env ファイルで定義
PORT=8000
DATABASE_URL=sqlite:///./data/app.db
LOG_LEVEL=info
```

## トラブルシューティング

### モジュール エラー
```bash
go mod tidy        # 不使用な依存関係を削除
go mod download    # 依存関係を再ダウンロード
```

### ビルドエラー
```bash
go clean -cache    # ビルドキャッシュをクリア
make server-clean  # ビルド成果物削除
```

### リント エラー
```bash
make server-fmt    # 自動フォーマット
make goimports     # import 自動整理
```

## 参考資料

- [Effective Go](https://golang.org/doc/effective_go)
- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [SQLite ドキュメント](https://www.sqlite.org/docs.html)
