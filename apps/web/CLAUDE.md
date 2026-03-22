# CommePlayer フロントエンド - 開発ガイド

## ディレクトリ構成

```
apps/web/
├── src/
│   ├── routes/           # TanStack Router ルート定義
│   ├── components/       # React コンポーネント
│   │   └── ui/          # shadcn-ui コンポーネント
│   ├── pages/           # ページコンポーネント（ルート対応）
│   ├── lib/             # ユーティリティ関数
│   ├── providers/       # プロバイダー（Query Client等）
│   ├── services/        # API クライアント（TanStack Query）
│   ├── stores/          # Zustand ストア（状態管理）
│   ├── types/           # TypeScript 型定義
│   ├── styles/          # グローバルスタイル
│   ├── main.tsx         # エントリポイント
│   └── router.ts        # TanStack Router 設定
├── vite.config.ts       # Vite 設定
├── tsconfig.json        # TypeScript 設定
├── tailwind.config.ts   # Tailwind CSS 設定
└── package.json         # 依存関係定義
```

## 開発ワークフロー

### 開発サーバー起動

```bash
cd apps/web
yarn install           # 初回のみ
yarn dev              # 開発サーバー起動（http://localhost:3000）
```

### コード品質チェック

```bash
# 型チェック（必須）
yarn typecheck

# リント（必須）
yarn lint

# ビルド検証
yarn build
```

## コーディング規約（TypeScript / React）


### コメント

```tsx
// コンポーネント説明（ファイル先頭）
/**
 * VideoPlayer - DPlayer を使用したビデオ再生コンポーネント
 *
 * Props:
 * - id: ビデオ ID
 * - commentList: 表示するコメント（弾幕）リスト
 */
export function VideoPlayer({ id, commentList }: VideoPlayerProps) {
  // 何をしているか、なぜそうするのかを記載
  const [isPlaying, setIsPlaying] = useState(false)

  // コメント表示の遅延を管理
  const [commentDelay, setCommentDelay] = useState(0)

  return (/* JSX */)
}
```

### 型安全性

```tsx
// any は避ける
const data: any = response.json()  // ❌ NG

// 明示的な型定義
interface Video {
  id: string
  title: string
  src: string
}

const data: Video = response.json()  // ✅ OK

// 複雑な型は Zod で検証
import { z } from 'zod'

const VideoSchema = z.object({
  id: z.string(),
  title: z.string(),
})

const data = VideoSchema.parse(response.json())
```

### 日付操作

```tsx
// ❌ 絶対に new Date() を使わない
const now = new Date()

// ✅ date-fns を使用
import { addDays, format } from 'date-fns'

const now = new Date()
const tomorrow = addDays(now, 1)
const formatted = format(now, 'yyyy-MM-dd')
```

## TanStack Router

### ルート定義

```tsx
// src/router.ts で一括定義
import { RootRoute, Route, createRouter } from '@tanstack/react-router'
import RootLayout from './routes/__root'
import HomePage from './routes/index'
import VideoPage from './routes/videos/$id'

const rootRoute = new RootRoute({
  component: RootLayout,
})

const indexRoute = new Route({
  getParentRoute: () => rootRoute,
  path: '/',
  component: HomePage,
})

const videoRoute = new Route({
  getParentRoute: () => rootRoute,
  path: '/videos/$id',
  component: VideoPage,
})

export const router = createRouter({
  routeTree: rootRoute.addChildren([indexRoute, videoRoute]),
})
```

### ルートコンポーネント

```tsx
// src/routes/index.tsx
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/')({
  component: HomePage,
})

function HomePage() {
  return <h1>Home</h1>
}
```

### パラメータ取得

```tsx
// 動的ルート：/videos/$id
import { useParams } from '@tanstack/react-router'

export default function VideoPage() {
  const { id } = useParams({ from: '/videos/$id' })

  return <h1>Video: {id}</h1>
}
```

## TanStack Query（API データ管理）

### クエリ定義

```tsx
// src/services/useVideosQuery.ts
import { useQuery } from '@tanstack/react-query'

export function useVideoQuery(id: string) {
  return useQuery({
    queryKey: ['videos', id],
    queryFn: () => fetch(`/api/v1/videos/${id}`).then(r => r.json()),
    staleTime: 5 * 60 * 1000, // 5分
  })
}

// コンポーネント内での使用
export function VideoPage({ id }: { id: string }) {
  const { data, isLoading, error } = useVideoQuery(id)

  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>

  return <div>{data.title}</div>
}
```

### ミューテーション（更新操作）

```tsx
import { useMutation, useQueryClient } from '@tanstack/react-query'

export function useAddCommentMutation() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (comment: Comment) =>
      fetch('/api/v1/comments', {
        method: 'POST',
        body: JSON.stringify(comment),
      }).then(r => r.json()),

    onSuccess: () => {
      // キャッシュを無効化して再フェッチ
      queryClient.invalidateQueries({ queryKey: ['comments'] })
    },
  })
}
```

## Zustand（状態管理）

```tsx
// src/stores/sidebar-store.ts
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface SidebarStore {
  isOpen: boolean
  toggle: () => void
}

export const useSidebarStore = create<SidebarStore>()(
  persist(
    (set) => ({
      isOpen: true,
      toggle: () => set((state) => ({ isOpen: !state.isOpen })),
    }),
    { name: 'sidebar-store' }
  )
)

// コンポーネント内での使用
export function Sidebar() {
  const { isOpen, toggle } = useSidebarStore()
  return <button onClick={toggle}>{isOpen ? 'Close' : 'Open'}</button>
}
```

## Tailwind CSS + shadcn-ui

### コンポーネント使用

```tsx
import { Button } from '@/components/ui/button'
import { Card } from '@/components/ui/card'

export function VideoCard() {
  return (
    <Card>
      <div className="p-6">
        <Button variant="outline">Play</Button>
      </div>
    </Card>
  )
}
```


## ビルド・デプロイ

```bash
# 本番ビルド
yarn build

# 出力：dist/ ディレクトリ

# ビルド結果をプレビュー
yarn preview
```

## トラブルシューティング

### 型エラー
```bash
yarn typecheck    # 型エラーを詳細に表示
```

### リント エラー
```bash
yarn lint --fix   # 自動修正（可能な場合）
```

### ホットリロードが動作しない
```bash
# vite.config.ts を確認
// server: { watch: { usePolling: true } }
```

### ポート競合（3000 が使用中）
```bash
# vite.config.ts でポート変更
// server: { port: 3001 }
```

## 参考資料

- [React ドキュメント](https://react.dev)
- [TanStack Router](https://tanstack.com/router)
- [TanStack Query](https://tanstack.com/query)
- [Zustand](https://github.com/pmndrs/zustand)
- [Tailwind CSS](https://tailwindcss.com)
- [shadcn-ui](https://ui.shadcn.com)
- [Vite ドキュメント](https://vitejs.dev)
