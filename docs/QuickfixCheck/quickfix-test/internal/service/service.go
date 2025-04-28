package service

import (
	"errors"
	"quickfix-test/pkg/models"
)

type Service struct{}

func NewService() *Service {
	return &Service{}
}

func (s *Service) GetItems() ([]models.Item, error) {
	// 故意错误：itemsCache 未定义
	return itemsCache, nil
}

func (s *Service) CreateItem(item models.Item) error {
	// 功能未实现
	return errors.New("not implemented")
}

// TODO: 实现更多功能
func (s *Service) UpdateItem(id string, item models.Item) error {
	return nil
}

func (s *Service) DeleteItem(id string) error {
	return nil
}
