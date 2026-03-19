# OpenAPI コード自動生成 - 完全ガイド

このプロジェクトでは、OpenAPI 2.0仕様（`docs/swagger.yaml`）から **Go Server** と **React Query TypeScript** クライアントコードを自動生成しています。

## 📦 生成されたコード

### サーバー側 (Go)

```
server/generated/
├── go/                          # Go実装ファイル
│   ├── api_captures.go          # Capturesエンドポイント
│   ├── api_videos.go            # Videosエンドポイント
│   ├── model_*.go               # データモデル
│   └── ...その他のファイル
├── api/openapi.yaml             # OpenAPI仕様書
├── main.go                       # エントリーポイント
├── Dockerfile                    # Docker設定
└── go.mod                        # Go依存関係
```

**特徴:**
- REST APIエンドポイント実装
- 型安全なデータモデル
- ルーティング設定
- エラーハンドリング

### クライアント側 (TypeScript + React Query)

```
frontend/src/generated/
├── apis/                         # APIクライアント実装
│   ├── CapturesApi.ts
│   └── VideosApi.ts
├── models/                       # TypeScript型定義
│   ├── Video.ts
│   ├── Capture.ts
│   └── ...その他のモデル
├── docs/                         # API仕様書
├── index.ts                      # エクスポートポイント
└── runtime.ts                    # ランタイム設定
```

**特徴:**
- TypeScript型安全
- Fetch APIベース
- 完全な型定義
- CORSサポート

**カスタムReact Queryフック:**
```
frontend/src/hooks/useVideosQuery.ts
```
- `useVideosQuery()` - ビデオ一覧取得
- `useSearchVideosQuery()` - ビデオ検索
- `useVideoQuery()` - 単一ビデオ取得
- `useCapturesQuery()` - キャプチャ一覧取得
- `useCreateCaptureMutation()` - キャプチャ作成
- `useRegenerateThumbnailMutation()` - サムネイル再生成
- `useVideoDownload()` - ビデオダウンロード

## 🚀 クイックスタート

### 1. 初回セットアップ

#### Linux/Mac:
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

#### Windows:
```cmd
scripts\setup.bat
```

### 2. Swagger定義を変更した場合

修正後、以下を実行：

```bash
# 両方を生成
make generate-all

# または個別に
make generate-server
make generate-client
```

### 3. 依存関係をインストール

```bash
npm install
```

## 📋 使用例

### React コンポーネントでの使用

```typescript
'use client';

import { useVideosQuery } from '@/hooks/useVideosQuery';

export function VideosList() {
  const { data, isLoading, error } = useVideosQuery({
    page: 1,
    limit: 20,
    sort: 'created_at',
    order: 'desc'
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <ul>
      {data?.data.map(video => (
        <li key={video.id}>{video.file_name}</li>
      ))}
    </ul>
  );
}
```

### Go Server での実装

生成されたコードは以下のようなインターフェースを提供します：

```go
type CapturesApiService interface {
    ApiV1CapturesGet(ctx context.Context, videoId *int32, page *int32, limit *int32) (ImplResponse, error)
    ApiV1CapturesPost(ctx context.Context, file *os.File, videoId int32) (ImplResponse, error)
}

type VideosApiService interface {
    ApiV1VideosGet(ctx context.Context, ids []int32, filterBy *string, page *int32, limit *int32, sort *string, order *string) (ImplResponse, error)
    ApiV1VideosSearchGet(ctx context.Context, q string, page *int32, limit *int32, order *string, filterBy *string) (ImplResponse, error)
    // ... その他のメソッド
}
```

これらのインターフェースを実装することでAPIロジックを構築します。

## 🔧 設定ファイル

### 環境変数

`.env.local` (フロントエンド):
```env
NEXT_PUBLIC_API_BASE_URL=http://localhost:8000
```

### Dockerfile (サーバー)

生成されたサーバーに Dockerfile が含まれます：

```dockerfile
FROM golang:latest
WORKDIR /api
COPY . .
RUN go build -o main .
CMD ["./main"]
```

## 📚 ドキュメント

- **コード生成詳細**: `docs/code-generation.md`
- **API仕様**: `server/generated/api/openapi.yaml`
- **モデル仕様**: `frontend/src/generated/docs/`

## 🔄 コード生成ワークフロー

```
docs/swagger.yaml
    ↓
docker-compose / make コマンド
    ↓
OpenAPI Generator
    ↓
├─ server/generated/     (Go Server)
└─ frontend/src/generated/ (TypeScript Fetch)
    ↓
frontend/src/hooks/useVideosQuery.ts (React Query ラッパー)
```

## 📋 利用可能なコマンド

### Makefile

```bash
make generate-all       # 両方を生成
make generate-server    # Go Serverのみ生成
make generate-client    # TypeScript クライアントのみ生成
make server            # レガシーコマンド (generate-server と同じ)
```

### Docker Compose

```bash
# 個別生成
docker-compose up openapi-go-server
docker-compose up openapi-typescript-react-query

# 全生成
docker-compose up
```

## 🔍 トラブルシューティング

### エラー: "モジュール '@/generated' が見つかりません"

**解決策:**
```bash
make generate-client
npm install
```

### エラー: "go.mod not found"

**解決策:**
```bash
cd server/generated
go mod tidy
```

### キャッシュ関連のエラー

```bash
docker-compose down -v
make generate-all
```

## 📖 参考リンク

- [OpenAPI Generator 公式ドキュメント](https://openapi-generator.tech/)
- [Go Server Generator](https://openapi-generator.tech/docs/generators/go-server/)
- [TypeScript Fetch Generator](https://openapi-generator.tech/docs/generators/typescript-fetch/)
- [React Query ドキュメント](https://tanstack.com/query/latest)
- [Swagger/OpenAPI 2.0 仕様](https://swagger.io/specification/v2/)

## ✅ 次のステップ

1. **サーバー実装**
   - `server/generated/go/impl.go` にビジネスロジックを実装
   - データベース接続を設定
   - 認証・認可機能を追加

2. **クライアント開発**
   - React コンポーネントで `useVideosQuery` などのフックを使用
   - UI/UX の実装

3. **テスト**
   - サーバーのユニットテスト作成
   - クライアントの integration テスト作成

4. **デプロイ**
   - Docker イメージをビルド
   - 本番環境へ配置

## 💡 ヒント

- Swagger定義を更新するたびに `make generate-all` を実行してください
- 生成されたコードは `generated/` ディレクトリに配置されるため、手動編集を避けてください
- API定義の変更は Swagger ファイルで行い、生成して反映させます
- React Query のキャッシュ戦略は `frontend/src/providers/QueryClientProvider.tsx` で管理できます

## 📝 ライセンス

このコード生成システムは OpenAPI Generator により生成されます。
各生成コードの利用に関しては OpenAPI Generator のライセンスに従います。
