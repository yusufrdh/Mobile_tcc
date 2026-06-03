package app

import (
	"context"
	"log/slog"
	"time"
)

func StartScheduler(store *Store, logger *slog.Logger) {
	ticker := time.NewTicker(5 * time.Minute)
	go func() {
		for range ticker.C {
			ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
			
			// FR-M06: Cek kelayakan donor setiap 5 menit
			_, err := store.RefreshEligibility(ctx)
			if err != nil {
				logger.Error("Gagal refresh eligibility", "error", err)
			}

			// Membatalkan broadcast yang sudah kedaluwarsa
			expired, err := store.ExpireBroadcasts(ctx)
			if err != nil {
				logger.Error("Gagal proses expire broadcast", "error", err)
			} else if expired > 0 {
				logger.Info("Menutup broadcast kadaluarsa", "jumlah", expired)
			}

			cancel()
		}
	}()
}