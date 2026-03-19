# OpenAPI コード自動生成ガイド

このドキュメントは、`docs/swagger.yaml`からGo Chi ServerとReact Query TypeScriptのコードを自動生成する方法を説明します。

## 概要

このプロジェクトでは、OpenAPI 2.0仕様（Swagger）から以下のコードを自動生成します：

1. **Go Chi Server** - RESTful APIサーバー実装
2. **React Query TypeScript** - フロントエンド型安全APIクライアント

## 前提条件

- Docker & Docker Compose
- Make (オプション)
- または直接 docker-compose コマンド実行

## 方法1: Makeコマンドを使用（推奨）

### サーバーコード生成

```bash
make generate-server
```

このコマンドは以下を実行します：
- Go Chi Serverのボイラープレートコードを生成
- 出力先: `server/generated/`
- パッケージ名: `generated`
- ポート: 8000

### クライアントコード生成

```bash
make generate-client
```

このコマンドは以下を実行します：
- TypeScript Fetchクライアントを生成
- React Query互換ラッパーコードを生成
- 出力先: `frontend/src/generated/`
- モデルパッケージ: `models`
- APIパッケージ: `api`

### 両方を一括生成

```bash
make generate-all
```

## 方法2: Docker Composeを使用

### 個別生成

#### Go Chi Server
```bash
docker-compose up openapi-go-chi-server
```

#### React Query クライアント
```bash
docker-compose up openapi-typescript-react-query
```

### 全サービス実行
```bash
docker-compose up
```

## 方法3: 直接Dockerコマンド

### Go Chi Server
```bash
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli \
  java -jar /openapi-generator-cli.jar generate \
  -i /local/docs/swagger.yaml \
  -g go-chi-server \
  -o /local/server/generated \
  --skip-validate-spec \
  --additional-properties=packageName=generated,hideGenerationTimestamp=true,serverPort=8000
```

### React Query TypeScript
```bash
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli \
  java -jar /openapi-generator-cli.jar generate \
  -i /local/docs/swagger.yaml \
  -g typescript-fetch \
  -o /local/frontend/src/generated \
  --additional-properties=typescriptThreePlus=true,supportsES6=true,hideGenerationTimestamp=true,modelPackage=models,apiPackage=api
```

## 生成されたコード

### サーバー側

生成ディレクトリ: `server/generated/`

主要ファイル：
- `go/` - Goモジュール実装
- `docs/` - API仕様書
- `go.mod` - Go依存関係

**使用方法：**
```go
import "server/generated"

// ハンドラーを実装
type VideoHandler struct{}

func (h *VideoHandler) ApiV1VideosGet(w http.ResponseWriter, r *http.Request) {
  // 実装
}
```

### クライアント側

生成ディレクトリ: `frontend/src/generated/`

主要ファイル：
- `api/` - APIクライアント
- `models/` - データモデル型定義

**使用方法：**
```typescript
import { useVideosQuery } from '@/hooks/useVideosQuery';

// React コンポーネントで使用
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
    <div>
      {data?.data.map(video => (
        <div key={video.id}>{video.file_name}</div>
      ))}
    </div>
  );
}
```

## React Query フック

`frontend/src/hooks/useVideosQuery.ts`に以下のフックが実装されています：

### クエリフック

- **useVideosQuery** - ビデオ一覧取得
  ```typescript
  const { data, isLoading } = useVideosQuery({
    page: 1,
    limit: 20,
    sort: 'created_at'
  });
  ```

- **useSearchVideosQuery** - ビデオ検索
  ```typescript
  const { data } = useSearchVideosQuery('検索キーワード', {
    page: 1,
    limit: 20
  });
  ```

- **useVideoQuery** - 単一ビデオ取得
  ```typescript
  const { data: video } = useVideoQuery(videoId);
  ```

- **useCapturesQuery** - キャプチャ一覧取得
  ```typescript
  const { data: captures } = useCapturesQuery({
    video_id: videoId,
    page: 1
  });
  ```

### ミューテーション

- **useCreateCaptureMutation** - キャプチャ作成
  ```typescript
  const { mutate } = useCreateCaptureMutation();
  mutate({ file, video_id: 1 });
  ```

- **useRegenerateThumbnailMutation** - サムネイル再生成
  ```typescript
  const { mutate } = useRegenerateThumbnailMutation();
  mutate({ id: 1, width: 300, height: 300 });
  ```

### ユーティリティ

- **useVideoDownload** - ビデオダウンロード
  ```typescript
  const download = useVideoDownload();
  download(videoId, 'video.mp4');
  ```

## キャッシュ戦略

すべてのクエリは以下のキャッシュ設定を使用します：
- **staleTime**: 5分（キャッシュが有効な時間）
- **cacheTime**: React Queryデフォルト（キャッシュ保持時間）

ミューテーション成功後、関連キャッシュは自動的に無効化されます。

## トラブルシューティング

### コード生成エラー

**症状**: `java.lang.UnsupportedOperationException`

**解決策**:
```bash
# docker-composeキャッシュをクリア
docker-compose down -v
make generate-all
```

### 型定義エラー

**症状**: `モジュール '@/generated/api' が見つかりません`

**解決策**:
```bash
# コード生成を実行
make generate-client
# 依存関係をインストール
npm install
```

### Go mod エラー

**症状**: `go.mod not found`

**解決策**:
```bash
cd server
go mod init video-app
go mod tidy
```

## APIベースURL設定

デフォルトでは `http://localhost:8000` を使用します。

環境変数で変更可能：
```bash
# .env.local (フロントエンド)
NEXT_PUBLIC_API_BASE_URL=https://api.example.com
```

## Swagger定義の変更後

1. `docs/swagger.yaml`を修正
2. コード生成を再実行
   ```bash
   make generate-all
   ```
3. フロントエンド依存関係の再インストール
   ```bash
   npm install
   ```

## 参考リンク

- [OpenAPI Generator](https://openapi-generator.tech/)
- [Go Chi Server Generator](https://openapi-generator.tech/docs/generators/go-chi-server/)
- [TypeScript Fetch Generator](https://openapi-generator.tech/docs/generators/typescript-fetch/)
- [React Query Documentation](https://tanstack.com/query/latest)
