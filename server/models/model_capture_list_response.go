package models

type CaptureListResponse struct {

	Data []Capture `json:"data"`

	Pagination Pagination `json:"pagination"`
}
