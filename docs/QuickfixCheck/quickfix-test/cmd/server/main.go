package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"  // 故意添加未使用的包

	"quickfix-test/internal/api"
	"quickfix-test/internal/config"
	"quickfix-test/internal/service"
)

func main() {
	// 故意添加未使用的变量，制造编译错误
	debugMode := true
	
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	svc := service.NewService()
	handler := api.NewHandler(svc)
	
	// 故意错误：参数顺序颠倒
	middleware := api.NewLoggingMiddleware(handler, cfg.LogLevel)
	
	router := http.NewServeMux()
	router.Handle("/api/", middleware)
	router.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "OK")
	})
	
	// 故意拼写错误：Prinln
	fmt.Prinln("Server starting on", cfg.Port)

	server := &http.Server{
		Addr:         fmt.Sprintf(":%d", cfg.Port),
		Handler:      router,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	log.Printf("Server listening on port %d", cfg.Port)
	if err := server.ListenAndServe(); err != nil {
		log.Fatal("Server failed to start:", err)
	}
}
