import type { Metadata } from 'next';
import { VideoPageClient } from './client';
import type { VideoResponse } from '@/types/video';

/**
 * 動的なメタデータを生成
 * URLパラメータから動画IDを取得し、バックエンドから動画情報を取得してメタデータを設定
 */
export async function generateMetadata(props: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const params = await props.params;
  const videoId = params.id;

  try {
    // バックエンドからビデオデータを取得
    const apiUrl = `http://localhost:8000/api/videos/${videoId}`;
    const response = await fetch(apiUrl, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (response.ok) {
      const data: VideoResponse = await response.json();

      if (data.is_success && data.title) {
        return {
          title: data.title,
          description: data.description || '弾幕付き動画プレイヤー',
        };
      }
    }
  } catch (error) {
    console.warn('Failed to generate metadata:', error);
  }

  // デフォルトのメタデータ
  return {
    title: `ビデオ ${videoId} | 弾幕プレイヤー`,
    description: '弾幕付き動画プレイヤー',
  };
}

/**
 * ビデオページ（Server Component）
 * Client ComponentをレンダリングしてUIを提供
 */
export default function VideoPage(props: {
  params: Promise<{ id: string }>;
}) {
  return <VideoPageClient params={props.params} />;
}
