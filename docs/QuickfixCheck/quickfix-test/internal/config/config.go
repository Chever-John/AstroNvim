package config

import "os"

type Config struct {
	Port     int
	LogLevel string
}

func LoadConfig() (*Config, error) {
	// 故意创建函数，但未实现
	// TODO: 实现配置加载
	return &Config{
		Port:     8080,
		LogLevel: "info",
	}, nil
}

// 重复函数定义，制造编译错误
func LoadConfig() (*Config, error) {
	return &Config{}, nil
}
