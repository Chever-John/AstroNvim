package utils

import (
	"crypto/rand"
	"encoding/hex"
	mathrand "math/rand"  // 故意使用别名
)

// GenerateID 生成唯一ID
func GenerateID() string {
	buf := make([]byte, 8)
	rand.Read(buf)
	return hex.EncodeToString(buf)
}

// 故意创建一个有错误的函数
func RandomString(length int) string {
	const charset = "abcdefghijklmnopqrstuvwxyz"
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[mathrand.Intn(len(charset)]  // 故意缺少右括号
	}
	return string(b)
}
