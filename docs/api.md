## API ドキュメント

### Videos

#### GET /api/v1/videos

ビデオ一覧を取得します。

**クエリパラメータ:**
- `page` (number): ページ番号（デフォルト: 1）
- `limit` (number): 1ページあたりのアイテム数（デフォルト: 20）
- `sort` (string): ソート順序。`created_at`, `views`, `file_name`など（デフォルト: created_at）
- `order` (string): `asc` または `desc`（デフォルト: desc）

**レスポンス例:**
```json
{
  "data": [
    {
      "id": 1,
      "file_name": "video.mp4",
      "folder_path": "/videos",
      "file_path": "/videos/video.mp4",
      "status": "ready",
      "file_hash": "abc123...",
      "file_size": 1024000,
      "jikkyo_comment_count": 10,
      "jikkyo_date": "2024-03-19T10:00:00Z",
      "views": 150,
      "liked": false,
      "screenshot_file_path": "/thumbnails/video.jpg",
      "duration": 3600.5,
      "created_at": "2024-03-19T10:00:00Z",
      "updated_at": "2024-03-19T10:00:00Z",
      "thumbnail_info": {
        "width": 1280,
        "height": 720,
        "generated_at": "2024-03-19T10:00:00Z"
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "total_pages": 5
  }
}
```

#### GET /api/v1/videos/search

キーワードでビデオを検索します。

**クエリパラメータ:**
- `q` (string, 必須): 検索キーワード
- `page` (number): ページ番号（デフォルト: 1）
- `limit` (number): 1ページあたりのアイテム数（デフォルト: 20）

**レスポンス例:**
```json
{
  "data": [
    {
      "id": 1,
      "file_name": "video.mp4",
      "folder_path": "/videos",
      "file_path": "/videos/video.mp4",
      "status": "ready",
      "file_hash": "abc123...",
      "file_size": 1024000,
      "jikkyo_comment_count": 10,
      "jikkyo_date": "2024-03-19T10:00:00Z",
      "views": 150,
      "liked": false,
      "screenshot_file_path": "/thumbnails/video.jpg",
      "duration": 3600.5,
      "created_at": "2024-03-19T10:00:00Z",
      "updated_at": "2024-03-19T10:00:00Z",
      "thumbnail_info": {
        "width": 1280,
        "height": 720,
        "generated_at": "2024-03-19T10:00:00Z"
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 5,
    "total_pages": 1
  }
}
```

#### GET /api/v1/videos/:id

特定のビデオ情報を取得します。

**パスパラメータ:**
- `id` (number, 必須): ビデオID

**レスポンス例 (200 OK):**
```json
{
  "id": 1,
  "file_name": "video.mp4",
  "folder_path": "/videos",
  "file_path": "/videos/video.mp4",
  "status": "ready",
  "file_hash": "abc123...",
  "file_size": 1024000,
  "jikkyo_comment_count": 10,
  "jikkyo_date": "2024-03-19T10:00:00Z",
  "views": 150,
  "liked": false,
  "screenshot_file_path": "/thumbnails/video.jpg",
  "duration": 3600.5,
  "created_at": "2024-03-19T10:00:00Z",
  "updated_at": "2024-03-19T10:00:00Z",
  "thumbnail_info": {
    "width": 1280,
    "height": 720,
    "generated_at": "2024-03-19T10:00:00Z"
  }
}
```

**エラーレスポンス例 (404 Not Found):**
```json
{
  "error": "Video not found"
}
```

#### GET /api/v1/videos/:id/download

ビデオファイルをダウンロードします。

**パスパラメータ:**
- `id` (number, 必須): ビデオID

**レスポンス:**
- ファイルストリーム（Content-Type: video/mp4など）

#### POST /api/v1/videos/:id/thumbnail/regenerate

ビデオのサムネイルを再生成します。

**パスパラメータ:**
- `id` (number, 必須): ビデオID

**リクエストボディ例:**
```json
{
  "width": 1280,
  "height": 720,
  "timestamp": 10
}
```

**レスポンス例 (200 OK):**
```json
{
  "id": 1,
  "thumbnail_info": {
    "width": 1280,
    "height": 720,
    "generated_at": "2024-03-19T10:30:00Z"
  },
  "message": "Thumbnail regenerated successfully"
}
```

### Captures

#### GET /api/v1/captures

キャプチャ一覧を取得します。

**クエリパラメータ:**
- `folder_id` (number): ビデオID（フィルタリング用）
- `page` (number): ページ番号（デフォルト: 1）
- `limit` (number): 1ページあたりのアイテム数（デフォルト: 20）

**レスポンス例:**
```json
{
  "data": [
    {
      "id": 1,
      "filename": "capture_001.jpg",
      "created_at": "2024-03-19T10:00:00Z",
      "folder_id": 1
    },
    {
      "id": 2,
      "filename": "capture_002.jpg",
      "created_at": "2024-03-19T10:05:00Z",
      "folder_id": 1
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 50,
    "total_pages": 3
  }
}
```

#### POST /api/v1/captures

新しいキャプチャを作成します。

**リクエストボディ例:**
```json
{
  "filename": "capture_001.jpg",
  "folder_id": 1
}
```

**レスポンス例 (201 Created):**
```json
{
  "id": 1,
  "filename": "capture_001.jpg",
  "created_at": "2024-03-19T10:00:00Z",
  "folder_id": 1
}
```

**エラーレスポンス例 (400 Bad Request):**
```json
{
  "error": "Invalid request body"
}
```
