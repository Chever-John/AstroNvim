package api

import (
	"log"
	"net/http"
)

type LoggingMiddleware struct {
	next     http.Handler
	logLevel string
}

func NewLoggingMiddleware(logLevel string, next http.Handler) *LoggingMiddleware {
	return &LoggingMiddleware{
		next:     next,
		logLevel: logLevel,
	}
}

func (m *LoggingMiddleware) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	log.Printf("[%s] %s %s", m.logLevel, r.Method, r.URL.Path)
	m.next.ServeHTTP(w, r)
}
