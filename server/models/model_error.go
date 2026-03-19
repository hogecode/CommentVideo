package models

type Error struct {

	// エラーメッセージ
	Error string `json:"error"`

	// エラーコード
	Code string `json:"code,omitempty"`
}
