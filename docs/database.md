
```sql
-- ビデオ
CREATE TABLE video (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    file_name TEXT NOT NULL,
    folder_path TEXT NOT NULL,
    file_path TEXT NOT NULL UNIQUE,
    status TEXT,
    file_hash TEXT NOT NULL,
    file_size INTEGER NOT NULL,
    jikkyo_comment_count INTEGER,
    jikkyo_date DATETIME,
    views INTEGER NOT NULL DEFAULT 0,
    liked BOOLEAN NOT NULL DEFAULT 0,
    screenshot_file_path TEXT,
    duration REAL NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    thumbnail_info JSON
);

CREATE INDEX idx_video_file_path ON video(file_path);


-- キャプチャ
CREATE TABLE capture (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    filename TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    folder_id INTEGER NOT NULL,
    FOREIGN KEY (folder_id) REFERENCES video(id) ON DELETE CASCADE
);

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL,
    password TEXT NOT NULL,
    is_admin INTEGER NOT NULL,
    client_settings JSON NOT NULL,
    niconico_user_id INTEGER,
    niconico_user_name TEXT,
    niconico_user_premium INTEGER,
    niconico_access_token TEXT,
    niconico_refresh_token TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```