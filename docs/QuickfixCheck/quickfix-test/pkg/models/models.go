package models

type Item struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	CreatedAt   string `json:"created_at"`
}

// 故意创建一个永远不会被使用的函数
func FormatItem(item Item) string {
	return item.ID + " - " + item.Name
}
