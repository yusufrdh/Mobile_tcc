package main

import (
	"context"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"backend/internal/app"
	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	cfg := app.LoadConfig()

	// Inisialisasi Database
	dbPool, err := pgxpool.New(context.Background(), cfg.DatabaseURL)
	if err != nil {
		logger.Error("Gagal koneksi database", "error", err)
		os.Exit(1)
	}
	defer dbPool.Close()

	// Inisialisasi Crypto & FCM
	qrCipher := app.NewQRCipher(cfg.QRSecretKey)
	fcmClient, err := app.NewFCMClient(cfg.FirebaseCredPath)
	if err != nil {
		logger.Warn("FCM belum terkonfigurasi, notifikasi dinonaktifkan", "error", err)
	}

	store := app.NewStore(dbPool, cfg, qrCipher)
	application := app.New(cfg, store, logger, fcmClient)

	// Jalankan Scheduler (Cron)
	app.StartScheduler(store, logger)

	srv := &http.Server{
		Addr:         ":" + cfg.Port,
		Handler:      application.Handler(),
		IdleTimeout:  time.Minute,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	go func() {
		logger.Info("Server berjalan", "port", cfg.Port)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Error("Server error", "error", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	logger.Info("Mematikan server...")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	_ = srv.Shutdown(ctx)
}