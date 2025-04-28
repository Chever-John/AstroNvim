package api

import (
	"encoding/json"
	"net/http"
	"quickfix-test/internal/service"
	"quickfix-test/pkg/models"
)

type Handler struct {
	service *service.Service
}

func NewHandler(svc *service.Service) *Handler {
	return &Handler{
		service: svc,
	}
}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// 未结束代码块，制造语法错误
	if r.Method == http.MethodGet {
		items, err := h.service.GetItems()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	
		json.NewEncoder(w).Encode(items)
	// 缺少大括号
}
